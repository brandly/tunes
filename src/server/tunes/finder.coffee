findit = require 'findit'
path = require 'path'
mmm = require 'mmmagic'
Magic = mmm.Magic
Q = require 'q'
spotify = require './spotify.coffee'
xml2js = require 'xml2js'
_ = require 'lodash'
Track = require './track.coffee'

magic = new Magic mmm.MAGIC_MIME_TYPE

getMIME = (file) ->
  deferred = Q.defer()
  magic.detectFile file, (err, mimeType) ->
    if err
      deferred.reject err
    else
      deferred.resolve mimeType
  deferred.promise

stripTrack = (track) ->
  return {
    title: track.title[0]
    artist: track.artist?.join(', ')
    album: track.album[0]
    file: "spotify:track:#{track.id[0]}"
  }

parseXML = (xml) ->
  deferred = Q.defer()
  xml2js.parseString xml, (err, res) ->
    if err
      deferred.reject err
    else
      # dig through XML for the tracks
      tracks = res.result.tracks[0].track
      deferred.resolve tracks.map(stripTrack)
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
  spotify.search
    query: query
    type: 'tracks'
    maxResults: resultsPerSource
  .then parseXML

resultsPerSource = 10
exports.search = (query) ->
  Q.all [
    localSearch(query)
    spotifySearch(query)
  ]
  .then (results) ->
    _.flatten results
