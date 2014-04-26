spotify = require './spotify/track.coffee'
local = require './local/track.coffee'

exports.create = (file) ->
  if file.indexOf('spotify:') is 0
    spotify.track file
  else
    local.track file
