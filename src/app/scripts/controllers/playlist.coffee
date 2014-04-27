angular.module('tunes')

.controller 'PlaylistCtrl', ['$scope', '$stateParams', '$tunes', ($scope, $stateParams, $tunes) ->
  $scope.name = $stateParams.name
  $scope.tracks = null

  $tunes.list($scope.name).then (tracks) ->
    $scope.tracks = tracks
]
