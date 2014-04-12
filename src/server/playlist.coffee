fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
id3 = require 'id3js'
Throttle = require 'throttle'

config =
  channels: 2
  bitDepth: 16
  sampleRate: 44100

class Playlist
  current: -1
  song: null
  file: null
  speaker: null
  throttle: null

  constructor: (@files = []) ->

  add: (file) ->
    @files.push file
    return file

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
    @pause()
    @file = file
    @throttle = new Throttle(config.bitDepth * config.sampleRate)
    decoder = new lame.Decoder
      channels: config.channels
      bitDepth: config.bitDepth
      sampleRate: config.sampleRate

    song = fs.createReadStream file
              .pipe decoder

    song.on 'error', (error) ->
      console.err 'error playing song:', error

    song.pipe @throttle
        .pipe @_speaker()

    @song = song
    return file

  resume: ->
    if @song?
      @song.resume()
      @song.pipe @throttle
           .pipe @_speaker()

  pause: ->
    if @song?
      @song.unpipe()
      @speaker.end()
      @song.pause()

  start: ->
    sound = @next()
    playing = @play sound

    id3 {file: sound, type: id3.OPEN_LOCAL}, (err, tags) ->
      throw err if err
      console.log "#np #{tags.v2.artist} - #{tags.v2.title}"

    playing.on 'finish', => @start()

  _speaker: ->
    @speaker = new Speaker()

module.exports = Playlist
