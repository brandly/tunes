id3 = require 'id3js'
Q = require 'q'
fs = require 'fs'
spotify = require './spotify.coffee'

spotifyTrack = (file) ->
  spotify.get(file).then (track) ->
    return {
      file: file
      title: track.name
      artist: track.artist[0].name
      album: track.album
      stream: track.play.bind(track)
    }

localTrack = (file) ->
  deferred = Q.defer()

  id3 {file: file, type: id3.OPEN_LOCAL}, (err, tags) ->
    deferred.reject err if err

    deferred.resolve {
      file: file
      title: tags.v2.title
      artist: tags.v2.artist
      album: tags.v2.album
      stream: -> fs.createReadStream(file)
    }

  deferred.promise

exports.create = (file) ->
  if file.indexOf('spotify:') is 0
    return spotifyTrack file
  else
    return localTrack file
