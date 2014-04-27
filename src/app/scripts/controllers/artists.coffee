angular.module('tunes')

.controller 'ArtistsCtrl', ['$scope', '$tunes', ($scope, $tunes) ->
  $scope.artists = null

  $tunes.artists().then (artists) ->
    $scope.artists = artists
]
