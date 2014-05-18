angular.module('tunes.directives')

.directive 'trackTable', ['$player', ($player) ->
  return {
    replace: true
    templateUrl: 'views/_track-table.html'
    scope:
      tracks: '='
    link: (scope, element, attrs) ->
      scope.playTrack = $player.play
  }
]
