finder = require './finder.coffee'
Playlist = require './playlist.coffee'

lastSearchResults = null
nowPlaying = null
playlist = null

rememberTrack = (track) ->
  nowPlaying = track

exports.search = (query) ->
  finder.search(query).then (results) ->
    lastSearchResults = results
    return results

# return np
exports.status = ->
  {nowPlaying}

# if np paused, play
exports.playByIndex = (i) ->
  playlist?.playByIndex(i).then rememberTrack

exports.resume = ->
  playlist?.resume()

exports.pause = ->
  playlist?.pause()

exports.next = ->
  playlist?.next().then rememberTrack

exports.prev = ->
  playlist?.prev().then rememberTrack

exports.add = (i) ->
  playlist?.add lastSearchResults[i]

exports.getList = ->
  playlist?.getTracks()

exports.list = (name) ->
  exports.pause()
  playlist = new Playlist name
  exports.getList()
