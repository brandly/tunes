angular.module('tunes.services', [])
angular.module('tunes.filters', [])
angular.module('tunes.directives', [])

dependencies = [
  'tunes.services'
  'tunes.filters'
  'tunes.directives'
  'ui.router'
]

angular.module('tunes', dependencies).config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider

    .state 'app',
      url: '/'
      templateUrl: 'views/app.html'
      controller: 'AppCtrl'

    .state 'search',
      parent: 'app'
      url: '/search?q'
      templateUrl: 'views/search.html'
      controller: 'SearchCtrl'

    .state 'artists',
      parent: 'app'
      url: '/artists'
      templateUrl: 'views/artists.html'
      controller: 'ArtistsCtrl'

    .state 'albums',
      parent: 'app'
      url: '/albums'
      templateUrl: 'views/albums.html'
      controller: 'AlbumsCtrl'

    $urlRouterProvider.otherwise '/'

])
