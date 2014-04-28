angular.module('tunes')

.controller 'SearchCtrl', ['$scope', '$stateParams', '$tunes', ($scope, $stateParams, $tunes) ->
  $scope.searchQuery = $stateParams.q
  $scope.searchResults = null

  $scope.loading = true
  $tunes.search($scope.searchQuery).then (tracks) ->
    $scope.searchResults = tracks
  .finally ->
    $scope.loading = false

  $scope.playTrack = (track) ->
    $tunes.play track.file
]
