fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
id3 = require 'id3js'

class Playlist
  current: -1
  song: null

  constructor: (@files = []) ->

  add: (file) ->
    @files.push file

  next: ->
    @current += 1
    if @current < @files.length
      return @files[@current]

  prev: ->
    @current = Math.min 0, @current - 1
    @files[@current]

  playByIndex: (index) ->
    @current = index
    @play @files[index]

  play: (file) ->
    song = fs.createReadStream file

    song.on 'error', (error) ->
      console.log 'error playing song:', error

    song.pipe new lame.Decoder()
        .pipe new Speaker()

    @song = song
    return file

  resume: ->
    @song?.resume()

  pause: ->
    @song?.pause()

  start: ->
    sound = @next()
    playing = @play sound

    id3 {file: sound, type: id3.OPEN_LOCAL}, (err, tags) ->
      throw err if err
      console.log "#np #{tags.v2.artist} - #{tags.v2.title}"

    playing.on 'finish', => @start()

module.exports = Playlist
