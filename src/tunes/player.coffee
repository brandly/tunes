Speaker = require 'speaker'
lame = require 'lame'
Throttle = require 'throttle'
Track = require './track'

config =
  channels: 2
  bitDepth: 16
  sampleRate: 44100

module.exports =
  play: (file) ->
    @stop()
    Track.create(file).then (track) =>
      @track = track
      song = track.stream().pipe @_decoder()

      song.on 'error', (error) ->
        console.err 'error playing song:', error

      song.pipe @_throttle()
          .pipe @_speaker()

      @song = song
      return @track

  resume: ->
    if @song?
      @song.resume()
      @song.pipe @throttle
           .pipe @_speaker()
      return @track

  pause: ->
    if @song?
      @song.unpipe()
      @speaker.end()
      @song.pause()
      return @track

  stop: ->
    @pause()
    @track = null

  _decoder: ->
    new lame.Decoder
      channels: config.channels
      bitDepth: config.bitDepth
      sampleRate: config.sampleRate

  _throttle: ->
    @throttle = new Throttle(config.bitDepth * config.sampleRate)

  _speaker: ->
    @speaker = new Speaker()
