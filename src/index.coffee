fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
finder = require './finder.coffee'
id3 = require 'id3js'

Playlist = (files = []) ->
  return {
    current: -1
    next: ->
      @current += 1
      if @current < files.length
        return files[@current]
  }

play = (file) ->
  song = fs.createReadStream file

  song.on 'error', (error) ->
    console.log 'error playing song:', error

  song.pipe new lame.Decoder()
      .pipe new Speaker()

query = process.argv[2]
console.log "searching for #{query}"

finder.search(query).then (results) ->
  console.log "found #{results.length}"

  playlist = Playlist results

  start = ->
    sound = playlist.next()
    playing = play sound

    id3 {file: sound, type: id3.OPEN_LOCAL}, (err, tags) ->
      throw err if err
      console.log "#np #{tags.v2.artist} - #{tags.v2.title}"

    playing.on 'finish', start

  start()
