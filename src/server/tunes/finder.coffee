Q = require 'q'
_ = require 'lodash'
local = require './local/search.coffee'
spotify = require './spotify/search.coffee'

resultsPerSource = 10
exports.search = (query) ->
  Q.all [
    local.search(query, resultsPerSource)
    spotify.search(query, resultsPerSource)
  ]
  .then (results) ->
    _.flatten results
