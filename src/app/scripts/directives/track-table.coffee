angular.module('tunes.directives')

.directive 'trackTable', ['$tunes', ($tunes) ->
  return {
    replace: true
    templateUrl: 'views/_track-table.html'
    scope:
      tracks: '='
    link: (scope, element, attrs) ->
      scope.playTrack = (track) ->
        $tunes.play track.file
  }
]
