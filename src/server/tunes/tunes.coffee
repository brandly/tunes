finder = require './finder.coffee'
Playlist = require './playlist.coffee'

lastSearchResults = null
nowPlaying = null
playlist = null

exports.search = (query) ->
  finder.search(query).then (results) ->
    lastSearchResults = results
    return results

# return np
exports.status = ->
  {nowPlaying}

# if np paused, play
exports.playByIndex = (i) ->
  playlist?.playByIndex(i).then (file) ->
    nowPlaying = file

exports.resume = ->
  playlist?.resume()

exports.pause = ->
  playlist?.pause()

exports.next = ->
  nowPlaying = playlist?.next()

exports.prev = ->
  nowPlaying = playlist?.prev()

exports.add = (i) ->
  playlist?.add lastSearchResults[i]

exports.getList = ->
  playlist?.files

exports.list = (name) ->
  exports.pause()
  playlist = new Playlist name
  exports.getList()

