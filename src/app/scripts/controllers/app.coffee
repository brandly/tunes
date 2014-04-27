angular.module('tunes')

.controller 'AppCtrl', ['$scope', '$tunes', '_', '$state', ($scope, $tunes, _, $state) ->
  $scope.query =
    search: ''
  $scope.playlists = null
  $scope.newPlaylist = ''

  $scope.$watch 'query.search', _.debounce (value) ->
    return $scope.searchResults = null unless value?.length
    $scope.$apply ->
      $state.go 'search',
        q: $scope.query.search
  , 300

  $scope.createPlaylist = (name) ->
    return unless name?.length
    $tunes.list(name).then refreshPlaylistList

  refreshPlaylistList = ->
    $tunes.listNames().then (playlists) ->
      $scope.playlists = playlists

  refreshPlaylistList()

  $scope.viewArtists = -> $state.go 'artists'
  $scope.viewAlbums = -> $state.go 'albums'
]
