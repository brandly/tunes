angular.module('tunes.services', [])
angular.module('tunes.filters', [])
angular.module('tunes.directives', [])

dependencies = [
    'tunes.services'
    'tunes.filters'
    'tunes.directives'
]

angular.module('tunes', dependencies)
