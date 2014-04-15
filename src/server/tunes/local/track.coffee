id3 = require 'id3js'
Q = require 'q'
fs = require 'fs'

exports.track = (file) ->
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
