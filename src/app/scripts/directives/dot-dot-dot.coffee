angular.module('tunes.directives')

.directive 'dotDotDot', ['$interval', ($interval) ->
  return {
    link: (scope, element, attrs) ->
      raw = element[0]
      i = 0
      values = [
        ''
        '.'
        '..'
        '...'
      ]
      maxIndex = values.length
      looper = $interval ->
        i = (i + 1) % maxIndex
        raw.innerText = values[i]
      , 200

      scope.$on '$destroy', ->
        $interval.cancel looper
  }
]
