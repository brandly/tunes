finder = require './finder.coffee'
Playlist = require './playlist.coffee'

lastSearchResults = null
nowPlaying = null
playlist = new Playlist []

exports.search = finder.search

# return np
exports.status = ->
  {nowPlaying}

# if np paused, play
exports.play = (index) ->
  if index?
    playlist.playByIndex index
  else
    playlist.resume()

# if np, pause it
exports.pause = ->
  playlist.pause()

exports.next = ->
  file = playlist.next()
  playlist.play file

exports.prev = ->
  file = playlist.prev()
  playlist.play file

# from last results, add that song
exports.add = (i) ->
  playlist.add lastSearchResults[i]
