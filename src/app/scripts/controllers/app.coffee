angular.module('tunes')

.controller 'AppCtrl', ['$scope', '$tunes', '_', ($scope, $tunes, _) ->
  $scope.query =
    search: ''
  $scope.searchResults = null

  $scope.$watch 'query.search', _.debounce (value) ->
    $scope.$apply ->
      $tunes.search(value).then (tracks) ->
        $scope.searchResults = tracks
  , 300
]
