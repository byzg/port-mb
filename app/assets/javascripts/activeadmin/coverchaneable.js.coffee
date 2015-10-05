window.CoverChangeable = class CoverChangeable
  constructor: (@album, modalOpener, title)->
    @$modal = $('#modal')
    modalOpener.click =>
      @$modal.modal()
      @setTitle(title)
      $.ajax
        url: "/admin/albums/#{@album.id}/cover_edit"
        type: 'GET'
        dataType: 'json'
      .done (data)=> @setContent(data)

  setTitle: (title)->
    @$modal.find('.modal-title').html(title)

  setContent: (data)->
    @$contentCnt ||= @$modal.find('.modal-body .container-fluid .row')
    $.each data, (_, src)=>
      console.log @
      console.log src
      @$contentCnt.append("<div col-xs-3><img src='#{src}'></div>")