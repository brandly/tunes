Q = require 'q'
db = require('./db').playlists

class Playlist

  constructor: (@name) ->

  load: ->
    db.get(@name).then (tracks) =>
      @tracks = tracks

  add: (track) ->
    @tracks.push track
    @save().then -> return track

  remove: (i) ->
    track = @tracks[i]
    @tracks.splice i, 1
    @save().then -> return track

  # next: ->
  #   return unless @tracks.length
  #   @current = (@current + 1) % @tracks.length
  #   @playByIndex @current

  # prev: ->
  #   return unless @tracks.length
  #   @current = Math.max 0, @current - 1
  #   @playByIndex @current

  # playByIndex: (index) ->
  #   @current = index
  #   @play @tracks[index].file

  # start: ->
  #   sound = @next()
  #   playing = @play sound
  #   playing.on 'finish', => @start()

  save: ->
    db.save
      name: @name
      files: @tracks.map (track) -> track.file

  getTracks: ->
    if @tracks
      Q(@tracks)
    else
      @load()

module.exports = Playlist
