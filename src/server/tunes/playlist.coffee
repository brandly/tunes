fs = require 'fs'
Speaker = require 'speaker'
lame = require 'lame'
Throttle = require 'throttle'
spotify = require './spotify.coffee'
Q = require 'q'

folder = './lists'

config =
  channels: 2
  bitDepth: 16
  sampleRate: 44100

ensureExists = (dir)->
  try
    fs.mkdirSync dir
  catch error
    if error.code isnt 'EEXIST'
      console.err 'ERROR', error

getList = (name) ->
  try
    JSON.parse fs.readFileSync("#{folder}/#{name}.json").toString('utf-8')
  catch e
    return []

stream = (file) ->
  if file.indexOf('spotify:') is 0
    spotify.stream file
  else
    deferred = Q.defer()
    deferred.resolve fs.createReadStream(file)
    return deferred.promise

class Playlist
  current: -1
  song: null
  file: null
  speaker: null
  throttle: null

  constructor: (@name) ->
    @files = getList @name

  add: (file) ->
    @files.push file
    @save()
    return file

  # remove: (i) ->

  next: ->
    return unless @files.length
    @current = (@current + 1) % @files.length
    @playByIndex @current

  prev: ->
    return unless @files.length
    @current = Math.max 0, @current - 1
    @playByIndex @current

  playByIndex: (index) ->
    @current = index
    @play @files[index]

  play: (file) ->
    @pause()
    @file = file
    stream(file).then (mp3) =>
      @throttle = new Throttle(config.bitDepth * config.sampleRate)
      decoder = new lame.Decoder
        channels: config.channels
        bitDepth: config.bitDepth
        sampleRate: config.sampleRate

      song = mp3.pipe decoder

      song.on 'error', (error) ->
        console.err 'error playing song:', error

      song.pipe @throttle
          .pipe @_speaker()

      @song = song
      return @file

  resume: ->
    if @song?
      @song.resume()
      @song.pipe @throttle
           .pipe @_speaker()
      return @file

  pause: ->
    if @song?
      @song.unpipe()
      @speaker.end()
      @song.pause()
      return @file

  # start: ->
  #   sound = @next()
  #   playing = @play sound
  #   playing.on 'finish', => @start()

  _speaker: ->
    @speaker = new Speaker()

  save: ->
    fs.writeFileSync "#{folder}/#{@name}.json", JSON.stringify(@files)

module.exports = Playlist
