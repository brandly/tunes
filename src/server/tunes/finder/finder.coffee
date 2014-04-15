Q = require 'q'
_ = require 'lodash'
local = require './local.coffee'
spotify = require './spotify.coffee'

resultsPerSource = 10
exports.search = (query) ->
  Q.all [
    local.search(query, resultsPerSource)
    spotify.search(query, resultsPerSource)
  ]
  .then (results) ->
    _.flatten results
