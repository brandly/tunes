angular.module('tunes')

.controller 'SearchCtrl', ['$scope', '$stateParams', '$tunes', ($scope, $stateParams, $tunes) ->
  $scope.searchResults = null

  $tunes.search($stateParams.q).then (tracks) ->
    $scope.searchResults = tracks
]
