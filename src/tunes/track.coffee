spotify = require './spotify/track'
local = require './local/track'

exports.create = (file) ->
  if file.indexOf('spotify:') is 0
    spotify.track file
  else
    local.track file
