Q = require 'q'
Spotify = require 'spotify-web'
config = require '../../config.json'

login = ->
  deferred = Q.defer()
  Spotify.login config.spotifyUsername, config.spotifyPassword, deferred.makeNodeResolver()
  deferred.promise

get = (spotify, uri) ->
  deferred = Q.defer()
  spotify.get uri, deferred.makeNodeResolver()
  deferred.promise

search = (spotify, query) ->
  deferred = Q.defer()
  spotify.search query, deferred.makeNodeResolver()
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
