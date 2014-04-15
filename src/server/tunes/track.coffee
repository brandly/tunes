spotify = require './spotify/track.coffee'
local = require './local/track.coffee'

exports.create = (file) ->
  if file.indexOf('spotify:') is 0
    return spotify.track file
  else
    return local.track file
