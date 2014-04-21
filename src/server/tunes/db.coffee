db = require 'nedb'
Q = require 'q'

Tracks = new db
  filename: "#{__dirname}/db/tracks.db"
  autoload: true

Tracks.ensureIndex
  fieldName: 'file'
  unique: true

Playlists = new db
  filename: "#{__dirname}/db/playlists.db"
  autoload: true

Playlists.ensureIndex
  fieldName: 'name'
  unique: true

exports.tracks =
  # whenever a track gets added, to a playlist, it should get added to the db
  add: (track) ->
    deferred = Q.defer()

    Tracks.update {
      file: track.file # upsert based on unique 'file'
    }, track, {
      upsert: true
    }, (err, t) ->
      if err
        deferred.reject err
      else
        deferred.resolve track

    deferred.promise

exports.playlists =
  # return a list of tracks
  get: (name) ->
    deferred = Q.defer()

    Playlists.findOne {name}, (err, playlist) ->
      deferred.reject err if err

      Tracks.find {
        file: {'$in': playlist.files}
      }, deferred.makeNodeResolver()

    deferred.promise

  save: (playlist) ->
    deferred = Q.defer()

    Playlists.update {
      name: playlist.name
    }, playlist, {
      upsert: true
    }, (err) ->
      if err
        deferred.reject err
      else
        deferred.resolve()

    deferred.promise
