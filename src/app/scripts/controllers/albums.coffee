angular.module('tunes')

.controller 'AlbumsCtrl', ['$scope', '$tunes', ($scope, $tunes) ->
  $scope.albums = null

  $tunes.albums().then (albums) ->
    $scope.albums = albums
]
