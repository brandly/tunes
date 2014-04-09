fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
finder = require './finder.coffee'
id3 = require 'id3js'

decoder = new lame.Decoder()
speaker = new Speaker()

Playlist = (files = []) ->
  return {
    current: -1
    next: ->
      @current += 1
      if @current < files.length
        return files[@current]
  }

query = process.argv[2]
console.log "searching for #{query}"

finder.search(query).then (results) ->
  console.log "found #{results.length}"

  play = (file) ->
    song = fs.createReadStream file

    song.pipe decoder
        .pipe speaker

    song.on 'error', (error) ->
      console.log 'error playing song:', error

  playlist = Playlist results

  start = ->
    sound = playlist.next()
    play sound

    id3 {file: sound, type: id3.OPEN_LOCAL}, (err, tags) ->
      throw err if err
      console.log "#np #{tags.v2.artist} - #{tags.v2.title}"

    sound.on 'finish', start

  start()
