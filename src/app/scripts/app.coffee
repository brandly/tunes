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

    $urlRouterProvider.otherwise '/'

])
