window.Backing = class Backing
  constructor: (@$element, @state = 'loading')->
    @$close = @$element.find('button.close')
    if @$close.length == 0
      @$close = $('<button type="button" class="close" aria-hidden="true">×</button>')
      @$element.append(@$close)
      @$close.click => @hide()
    @$message = @$element.find('.message')
    if @$message.length == 0
      @$message = $('<div class="message"></div>')
      @$element.append(@$message)

  skipState: ->
    @$element.removeClass(@state)
    @state = 'loading'
    @$element.addClass(@state)

  show: -> @$element.show()

  hide: ->
    @$element.hide()
    @skipState()

  danger: (message)->
    @$message.html(message)
    @state = 'danger'
    @$element.addClass(@state)