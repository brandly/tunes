finder = require './finder.coffee'
Playlist = require './playlist.coffee'

query = process.argv[2]
console.log "searching for #{query}"

finder.search(query).then (results) ->
  console.log "found #{results.length}"

  playlist = new Playlist results
  playlist.start()
