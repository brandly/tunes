fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
Throttle = require 'throttle'
Q = require 'q'
Track = require './track.coffee'
_ = require 'lodash'
db = require('./db.coffee').playlists

folder = './lists'

config =
  channels: 2
  bitDepth: 16
  sampleRate: 44100

class Playlist
  current: -1
  song: null
  track: null
  speaker: null
  throttle: null

  constructor: (@name) ->

  load: ->
    db.get(@name).then (tracks) =>
      @tracks = tracks

  add: (track) ->
    @tracks.push track
    @save().then -> return track

  # remove: (i) ->

  next: ->
    return unless @tracks.length
    @current = (@current + 1) % @tracks.length
    @playByIndex @current

  prev: ->
    return unless @tracks.length
    @current = Math.max 0, @current - 1
    @playByIndex @current

  playByIndex: (index) ->
    @current = index
    @play @tracks[index].file

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

  # start: ->
  #   sound = @next()
  #   playing = @play sound
  #   playing.on 'finish', => @start()

  _decoder: ->
    new lame.Decoder
      channels: config.channels
      bitDepth: config.bitDepth
      sampleRate: config.sampleRate

  _throttle: ->
    @throttle = new Throttle(config.bitDepth * config.sampleRate)

  _speaker: ->
    @speaker = new Speaker()

  save: ->
    db.save
      name: @name
      files: @tracks.map (track) -> track.file

  getTracks: ->
    Q(@tracks)

module.exports = Playlist
