window.Backing = class Backing
  constructor: (@$element, @state = 'loading')->
    @original = @$element.data('backing')
    unless @original
      @$element.data('backing', @)
      @$close = $('<button type="button" class="close" aria-hidden="true">×</button>')
      @$element.append(@$close)
      @$close.click => @hide()
      @$message = $('<div class="message"></div>')
      @$element.append(@$message)


  skipState: ->
    if @original
      @original.skipState()
    else
      console.log @state
      @$element.removeClass(@state)
      @state = 'loading'
      @$element.addClass(@state)

  show: ->
    if @original
      @original.show()
    else
      @$element.show()

  hide: ->
    if @original
      @original.hide()
    else
      @$element.hide()
      @skipState()

  danger: (message)->
    if @original
      @original.danger(message)
    else
      @$message.html(message)
      @state = 'danger'
      @$element.addClass(@state)
