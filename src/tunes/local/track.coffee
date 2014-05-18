id3 = require 'id3js'
Q = require 'q'
fs = require 'fs'

exports.track = (file) ->
  deferred = Q.defer()

  id3 {file: file, type: id3.OPEN_LOCAL}, (err, tags) ->
    deferred.reject err if err

    deferred.resolve {
      file: file
      title: tags.title
      artist: tags.artist
      album: tags.album
      stream: -> fs.createReadStream(file)
    }

  deferred.promise
