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

handle = (deferred) ->
  return (err, res) ->
    if err
      deferred.reject err
    else
      deferred.resolve res

get = (spotify, uri) ->
  deferred = Q.defer()
  spotify.get uri, handle deferred
  deferred.promise

search = (spotify, query) ->
  deferred = Q.defer()
  spotify.search query, handle deferred
  deferred.promise

exports.get = (uri) ->
  login().then (spotify) ->
    get spotify, uri
  , (e) ->
    console.log 'ERROR GETTING', e

exports.search = (query) ->
  login().then (spotify) ->
    search spotify, query

login()
