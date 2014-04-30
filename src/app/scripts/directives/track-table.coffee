angular.module('tunes.directives')

.directive 'trackTable', [ ->
  return {
    replace: true
    templateUrl: 'views/_track-table.html'
    scope:
      tracks: '='
  }
]
