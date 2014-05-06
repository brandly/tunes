angular.module('tunes.directives')

.directive 'dropTrack', [ ->
  return {
    scope:
      onDrop: '&dropTrack'
    link: (scope, element, attrs) ->
      element.on 'dragover', (e) ->
        e.preventDefault()

      element.on 'drop', (e) ->
        e.preventDefault()
        # TODO: there's _probably_ a better way
        scope.$parent.file = e.dataTransfer.getData('text')
        scope.onDrop()

      className = 'dropping'
      element.on 'dragenter', ->
        element.addClass className

      element.on 'dragleave', ->
        element.removeClass className

      element.on 'drop', ->
        element.removeClass className
  }
]
