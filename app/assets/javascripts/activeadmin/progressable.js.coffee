$ ->
  window.Progressable = class Progressable
    constructor: (@container)->
      @bar = @container.find('.progress-bar')
      @label = @bar.find('.label')

    start: (maxValue)=>
      @valueNow = parseFloat(@bar.attr('aria-valuenow'))
      @valueStart = @valueNow
      @valueMin = parseFloat(@bar.attr('aria-valuemin'))
      @valueMax = parseFloat(maxValue)      
      @bar.attr('aria-valuemax', @valueMax)
      @label.html "0/#{@valueMax}"
      @container.show()

    finish: =>
      @container.hide()
      @bar.attr('aria-valuenow', @valueStart)
      @bar.css('width', "#{@valueStart}%")
      @bar.removeAttr('aria-valuemax')
      @label.html ''

    tick: =>
      if @valueNow + 1 < @valueMax
        @valueNow += 1
        @bar.attr('aria-valuenow', @valueNow)
        @bar.css('width', "#{100 * @valueNow / (@valueMax - @valueMin)}%")
        @label.html "#{@valueNow}/#{@valueMax}"
      else
        @finish()
