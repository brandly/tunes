spotify = require './spotify.coffee'

exports.track = (file) ->
  spotify.get(file).then (track) ->
    return {
      file: file
      title: track.name
      artist: track.artist[0].name
      album: track.album
      stream: track.play.bind(track)
    }
