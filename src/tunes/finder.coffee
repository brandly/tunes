Q = require 'q'
_ = require 'lodash'
local = require './local/search'
spotify = require './spotify/search'

resultsPerSource = 30
exports.search = (query) ->
  Q.all [
    local.search(query, resultsPerSource)
    spotify.search(query, resultsPerSource)
  ]
  .then (results) ->
    _.flatten results
