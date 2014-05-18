mm = require 'musicmetadata'
Q = require 'q'
fs = require 'fs'

exports.track = (file) ->
  deferred = Q.defer()

  fileStream = fs.createReadStream(file)
  parser = mm fileStream

  parser.on 'metadata', (tag) ->
    deferred.resolve {
      file: file
      title: tag.title
      artist: tag.artist.join ', '
      album: tag.album
      stream: -> fileStream
    }

  parser.on 'done', (err) ->
    deferred.reject err if err

  deferred.promise
