findit = require 'findit'
path = require 'path'
mmm = require 'mmmagic'
Magic = mmm.Magic
Q = require 'q'

base = process.env.HOME + '/Music'
finder = findit base
magic = new Magic mmm.MAGIC_MIME_TYPE

exports.search = (query) ->
  query = query or throw 'whoaaa you gotta look for something'
  query = query.toLowerCase()

  deferred = Q.defer()
  searchResults = []
  finder.on 'file', (file) ->
    if file.toLowerCase().indexOf(query) > -1
      magic.detectFile file, (err, mimeType) ->
        throw err if err

        if mimeType is 'audio/mpeg'
          searchResults.push file

          if searchResults.length >= 100
            finder.stop()

            returnResults searchResults

  finder.on 'end', ->
    returnResults searchResults

  returnResults = (results) ->
    deferred.resolve results

  return deferred.promise
