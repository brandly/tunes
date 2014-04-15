request = require 'request'
Q = require 'q'
xml2js = require 'xml2js'

exports.search = (query, count) ->
  deferred = Q.defer()
  request.get "http://ws.spotify.com/search/1/track?q=#{encodeURIComponent query}", (e, r, body) ->
    parseXML(body, count).then deferred.resolve, deferred.reject

  deferred.promise

parseXML = (xml, count) ->
  deferred = Q.defer()
  xml2js.parseString xml, (err, res) ->
    if err
      deferred.reject err
    else
      # dig through XML for the tracks
      tracks = res.tracks.track
      deferred.resolve tracks.slice(0, count).map(stripTrack)
  deferred.promise

stripTrack = (track) ->
  return {
    title: track.name[0]
    artist: track.artist?.map(getName).join(', ')
    album: getName track.album[0]
    file: track.$.href
  }

getName = (item) ->
  item.name[0]
