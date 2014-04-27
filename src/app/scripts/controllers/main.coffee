angular.module('tunes')

.controller 'MainCtrl', ['$scope', '$tunes', ($scope, $tunes) ->
  $scope.sup = 'hellllllo'
  $scope.tracks = null

  $tunes.search('wayne').then (tracks) ->
    $scope.tracks = tracks
]
