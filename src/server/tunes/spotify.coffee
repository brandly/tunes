Q = require 'q'
Spotify = require 'spotify-web'
config = require '../../config.json'

login = ->
  deferred = Q.defer()
  Spotify.login config.spotifyUsername, config.spotifyPassword, (err, spotify) ->
    if err
      deferred.reject err
    else
      deferred.resolve spotify
  deferred.promise

get = (spotify, uri) ->
  deferred = Q.defer()
  spotify.get uri, (err, track) ->
    if err
      deferred.reject err
    else
      deferred.resolve track.play()
  deferred.promise

exports.stream = (uri) ->
  login().then (spotify) ->
    get spotify, uri

login()
