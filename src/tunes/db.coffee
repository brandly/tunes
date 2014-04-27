db = require 'nedb'
Q = require 'q'
_ = require 'lodash'

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

# return all unique values for a field within a collection
unique = (collection, field) ->
  return ->
    deferred = Q.defer()

    collection.find {}, (err, objects) ->
      return deferred.reject err if err

      uniques = {}
      objects.forEach (obj) ->
        uniques[obj[field]] = true

      deferred.resolve _.keys(uniques).sort()

    deferred.promise

exports.tracks =
  # whenever a track gets added, to a playlist, it should get added to the db
  add: (track) ->
    deferred = Q.defer()

    Tracks.update {
      file: track.file # upsert based on unique 'file'
    }, track, {
      upsert: true
    }, (err) ->
      if err
        deferred.reject err
      else
        deferred.resolve track

    deferred.promise

  artists: unique(Tracks, 'artist')

  albums: unique(Tracks, 'album')

exports.playlists =
  # return a list of tracks
  get: (name) ->
    deferred = Q.defer()

    Playlists.findOne {name}, (err, playlist) ->
      return deferred.reject err if err

      if playlist?.files?
        Tracks.find {
          file: {'$in': playlist.files}
        }, deferred.makeNodeResolver()
      else
        Playlists.insert {
          name: name
          files: []
        }, (err) ->
          return deferred.reject err if err

          # return empty list of tracks
          deferred.resolve []

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

  names: unique(Playlists, 'name')
