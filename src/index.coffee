finder = require './finder.coffee'
Playlist = require './playlist.coffee'

query = process.argv[2]
console.log "searching for #{query}"

finder.search(query).then (files) ->
  console.log "found #{files.length}"

  playlist = new Playlist files
  playlist.start()
