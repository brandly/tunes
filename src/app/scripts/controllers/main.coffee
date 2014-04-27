angular.module('tunes')

.controller 'MainCtrl', ['$scope', '$tunes', '_', ($scope, $tunes, _) ->
  $scope.sup = 'hellllllo'
  $scope.query =
    search: ''
  $scope.tracks = null

  $scope.$watch 'query.search', _.debounce (value) ->
    $scope.$apply ->
      $tunes.search(value).then (tracks) ->
        $scope.tracks = tracks
  , 300
]
