Q = require 'q'
findit = require 'findit'
mmm = require 'mmmagic'
Magic = mmm.Magic
Track = require '../track'
magic = new Magic mmm.MAGIC_MIME_TYPE

exports.search = (query, count) ->
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

            if searchResults.length >= count
              finder.stop()

              returnResults searchResults

  finder.on 'end', ->
    returnResults searchResults

  returnResults = (results) ->
    deferred.resolve results

  deferred.promise

getMIME = (file) ->
  deferred = Q.defer()
  magic.detectFile file, (err, mimeType) ->
    if err
      deferred.reject err
    else
      deferred.resolve mimeType
  deferred.promise
