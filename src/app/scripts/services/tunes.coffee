angular.module('tunes.services')

.service '$tunes', ['$q', ($q) ->
  tunesLib = require('./tunes/tunes')

  promises = [
    'search'
    'playByIndex'
    'next'
    'prev'
    'add'
    'getList'
    'list'
    'listNames'
    'artists'
    'albums'
  ]

  values = [
    'status'
    'resume'
    'pause'
    'remove'
  ]

  tunes = {}

  promises.forEach (method) ->
    tunes[method] = ->
      deferred = $q.defer()
      tunesLib[method]().then deferred.resolve, deferred.reject
      deferred.promise

  values.forEach (method) ->
    tunes[method] = tunesLib[method]

  return tunes
]
