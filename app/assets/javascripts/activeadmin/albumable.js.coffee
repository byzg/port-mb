$ ->
  window.Albumable = class Albumable
    setEmptyLabel = (text)->
      (($) ->$.fn.selectpicker.defaults = noneSelectedText: text)(jQuery)

    constructor: (@resourceName)->      
      @collection = []

    push: ($select, resourceId, currentAlbumId)=>
      setEmptyLabel('Поместить в альбом')
      @collection.push
        select: $select
        resourceId: resourceId
      @globalCnt.show() if @globalCnt?
      $select.val(currentAlbumId)
      $select.selectpicker()
      $select.change =>
        unless @globalChange
          val = $select.val()
          data = "{\"#{@resourceName}\": {\"album_id\": \"#{val}\"}}"
          data = $.parseJSON data
          $.ajax 
            url: "/admin/#{@resourceName}s/#{resourceId}"
            type: 'PUT'
            dataType: 'json'
            data: data

    global: ($selectCnt)->
      @globalCnt = $selectCnt
      @global = @globalCnt.find('select')
      setEmptyLabel('Поместить все в альбом')
      @global.selectpicker()
      $submitter = @globalCnt.find('.ok')
      $submitter.click =>
        @globalChange = true
        val = @global.val()
        data = _.map @collection, (pair)->
          {id: pair.resourceId, album_id: val}
        $.ajax
          url: '/admin/photos/albumable'
          type: 'PUT'
          data: {photos: data}
          dataType: 'json'
        .always =>
          _.each @collection, (pair)=>
            pair.select.val(val)
            pair.select.selectpicker('render')
          $submitter.prop('disabled', true)
          @globalChange = false
      @global.change =>
        val = @global.val()
        @globalCnt.find('.ok').prop('disabled', val == '')
        

    showGlobal: ->
      @globalCnt.show()

    hideGlobal: ->
      @globalCnt.hide()



        
