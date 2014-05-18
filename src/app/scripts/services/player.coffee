angular.module('tunes.services')

.service '$player', ['$tunes', ($tunes) ->
  player =
    nowPlaying: null

    play: (track) ->
      player.nowPlaying = track
      $tunes.play track.file

    pause: $tunes.pause
]
