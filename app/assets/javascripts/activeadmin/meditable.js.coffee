$ ->
  window.mEditable = class mEditable
    resultStyling = (result)->      
      result.addClass('form-control')
      padding = 6
      result.css('padding', "0 #{padding}px 0 #{padding}px")
      result.css('width', "#{result.parent().width() - 2 * padding}px")
      result.css('height', '20px')

    constructor: (@source, @opts)->
      @opts = $.extend {}, @opts
      @setOpacity('0.4')
      @source.html($.trim(@source.html()))
      @placeholder = @source.html()
      @source.click @onClick

    setOpacity: (op)->
      @source.css('opacity', op)

    content: => 
      if @source.html() == @placeholder then '' else @source.html()

    contentChanged: => @freezeContent != @content()

    onClick: =>
      @result = $("<input type='text' placeholder='#{@placeholder}'>")
      @result.val(@content())
      @freezeContent = @content()
      @source.hide()
      @source.after @result
      resultStyling(@result)
      @result.focus()
      @result.focusout @onBlur
      @result.keypress @onKeypress

    onKeypress: (event)=>
      keycode = if event.keyCode then event.keyCode else event.which
      @result.blur() if keycode == 13

    onBlur: =>
      val = @result.val()
      if val.length > 0
        @setOpacity('1')
        @source.html(val)
      else
        @setOpacity('0.4')
        @source.html(@placeholder)
      @source.show()
      @result.remove()
      @submit() if @contentChanged()

    submit: =>
      data = $.parseJSON @opts.dataWrap.replace('@', "\"#{@content()}\"")
      $.ajax
        url: @opts.url
        type: 'PUT'
        dataType: 'json'
        data: data

