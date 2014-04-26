finder = require './finder'
Playlist = require './playlist'
player = require './player'
db = require './db'

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

exports.remove = (i) ->
  playlist.remove i

exports.getList = ->
  playlist?.getTracks()

exports.list = (name) ->
  playlist = new Playlist name
  playlist.load()

exports.listNames = ->
  db.playlists.names()

exports.artists = ->
  db.tracks.artists()

exports.albums = ->
  db.tracks.albums()
