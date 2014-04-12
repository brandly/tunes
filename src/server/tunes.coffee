finder = require './finder.coffee'
Playlist = require './playlist.coffee'

lastSearchResults = null
nowPlaying = null
playlist = new Playlist []

exports.search = (query) ->
  finder.search(query).then (results) ->
    lastSearchResults = results
    return results

# return np
exports.status = ->
  {nowPlaying}

# if np paused, play
exports.play = (i) ->
  if i?
    nowPlaying = playlist.playByIndex i
  else
    playlist.resume()

# if np, pause it
exports.pause = ->
  playlist.pause()

exports.next = ->
  nowPlaying = playlist.next()

exports.prev = ->
  nowPlaying = playlist.prev()

# from last results, add that song
exports.add = (i) ->
  playlist.add lastSearchResults[i]
