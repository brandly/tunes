angular.module('tunes.services')

.service '$player', ['$tunes', ($tunes) ->
  player =
    nowPlaying: null
    paused: true

    play: (track) ->
      player.nowPlaying = track
      $tunes.play(track.file).then ->
        player.paused = false

    resume: ->
      if player.nowPlaying
        $tunes.resume()
        player.paused = false

    pause: ->
      $tunes.pause()
      player.paused = true
]
