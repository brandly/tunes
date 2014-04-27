angular.module('tunes')

.controller 'SearchCtrl', ['$scope', '$stateParams', '$tunes', ($scope, $stateParams, $tunes) ->
  $scope.searchQuery = $stateParams.q
  $scope.searchResults = null

  $tunes.search($scope.searchQuery).then (tracks) ->
    $scope.searchResults = tracks

  $scope.playTrack = (track) ->
    $tunes.play track.file
]
