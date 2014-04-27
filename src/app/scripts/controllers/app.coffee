angular.module('tunes')

.controller 'AppCtrl', ['$scope', '$tunes', '_', ($scope, $tunes, _) ->
  $scope.query =
    search: ''
  $scope.searchResults = null
  $scope.playlists = null
  $scope.newPlaylist = ''

  $scope.$watch 'query.search', _.debounce (value) ->
    return $scope.searchResults = null unless value?.length
    $scope.$apply ->
      $tunes.search(value).then (tracks) ->
        $scope.searchResults = tracks
  , 300

  $scope.createPlaylist = (name) ->
    return unless name?.length
    $tunes.list(name).then refreshPlaylistList

  refreshPlaylistList = ->
    $tunes.listNames().then (playlists) ->
      $scope.playlists = playlists

  refreshPlaylistList()
]
