window.Backing = class Backing
  constructor: (@$element, @state = 'loading')->
    @$close = $('<button type="button" class="close" aria-hidden="true">×</button>')
    @$element.append(@$close)
    @$message = $('<div class="message"></div>')
    @$element.append(@$message)

  skipState: -> @state = 'loading'

  show: -> @$element.show()

  hide: ->
    @$element.hide()
    @skipState()

  danger: (message)->
    @$message.html(message)
    @state = 'danger'
    @$element.addClass(@state)