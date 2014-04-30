angular.module('tunes.directives')

.directive 'dragTrack', [ ->
  return {
    scope:
      data: '@dragTrack'
    link: (scope, element, attrs) ->
      element.attr 'draggable', true

      element.on 'dragstart', (e) ->
        element.addClass 'dragging'
        e.dataTransfer.setData 'text', scope.data

      element.on 'dragend', ->
        element.removeClass 'dragging'
  }
]
