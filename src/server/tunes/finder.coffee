findit = require 'findit'
path = require 'path'
mmm = require 'mmmagic'
Magic = mmm.Magic
Q = require 'q'
xml2js = require 'xml2js'
_ = require 'lodash'
Track = require './track.coffee'
request = require 'request'

magic = new Magic mmm.MAGIC_MIME_TYPE

getMIME = (file) ->
  deferred = Q.defer()
  magic.detectFile file, (err, mimeType) ->
    if err
      deferred.reject err
    else
      deferred.resolve mimeType
  deferred.promise

getName = (item) ->
  item.name[0]

stripTrack = (track) ->
  return {
    title: track.name[0]
    artist: track.artist?.map(getName).join(', ')
    album: getName track.album[0]
    file: track.$.href
  }

parseXML = (xml) ->
  deferred = Q.defer()
  xml2js.parseString xml, (err, res) ->
    if err
      deferred.reject err
    else
      # dig through XML for the tracks
      tracks = res.tracks.track
      deferred.resolve tracks.slice(0, resultsPerSource).map(stripTrack)
  deferred.promise

localSearch = (query) ->
  query = query or throw 'whoaaa you gotta look for something'
  query = query.toLowerCase()

  base = process.env.HOME + '/Music'
  finder = findit base

  deferred = Q.defer()
  searchResults = []
  finder.on 'file', (file) ->
    if file.toLowerCase().indexOf(query) > -1
      getMIME(file).then (mimeType) ->
        if mimeType is 'audio/mpeg'
          Track.create(file).then (track) ->
            searchResults.push track

            if searchResults.length >= resultsPerSource
              finder.stop()

              returnResults searchResults

  finder.on 'end', ->
    returnResults searchResults

  returnResults = (results) ->
    deferred.resolve results

  deferred.promise

spotifySearch = (query) ->
  deferred = Q.defer()
  request.get "http://ws.spotify.com/search/1/track?q=#{encodeURIComponent query}", (e, r, body) ->
    parseXML(body).then deferred.resolve, deferred.reject

  deferred.promise

resultsPerSource = 10
exports.search = (query) ->
  Q.all [
    localSearch(query)
    spotifySearch(query)
  ]
  .then (results) ->
    _.flatten results
