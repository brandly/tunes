finder = require './finder.coffee'
Playlist = require './playlist.coffee'
player = require './player.coffee'
db = require './db.coffee'

lastSearchResults = null
nowPlaying = null
playlist = null

rememberTrack = (track) ->
  nowPlaying = track

exports.search = (query) ->
  finder.search(query).then (results) ->
    lastSearchResults = results
    return results

exports.status = ->
  {nowPlaying}

# if np paused, play
exports.playByIndex = (i) ->
  player.play(playlist.tracks[i].file).then rememberTrack

exports.resume = ->
  player.resume()

exports.pause = ->
  player.pause()

exports.next = ->
  playlist?.next().then rememberTrack

exports.prev = ->
  playlist?.prev().then rememberTrack

exports.add = (i) ->
  db.tracks.add(lastSearchResults[i]).then (track) ->
    if playlist?
      playlist.add track
    else
      track

exports.getList = ->
  playlist?.getTracks()

exports.list = (name) ->
  exports.pause()
  playlist = new Playlist name
  playlist.load()
