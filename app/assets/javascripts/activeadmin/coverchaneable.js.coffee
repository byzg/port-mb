window.CoverChangeable = class CoverChangeable
  constructor: (@album, @$modalOpener, title)->
    @$modal = $('#modal')
    @$loading = @$modal.find('.loading').parent()
    @$modalOpener.click =>
      @$modal.modal()
      @setTitle(title)
      @$loading.show()
      $.ajax
        url: "/admin/albums/#{@album.id}/cover_edit"
        type: 'GET'
        dataType: 'json'
      .done (data)=>
        @photos = data
        @$loading.hide()
        @setContent(data)
        @handleUpdate()

  setTitle: (title)->
    @$modal.find('.modal-title').html(title)

  setContent: (data)->
    @$contentCnt ||= @$modal.find('.modal-body .container-fluid .row')
    photos = ''
    $.each data, (_, photo)=>
      photos += "<div class='col-xs-4 pointer set-cover'
          data-image-id='#{photo.id}' data-album-id='#{@album.id}'>
          <img class='black-white-hover' src='#{photo.img}'>
        </div>"
    @$contentCnt.html(photos)

  _find: (id)-> _.find @photos, (photo)-> photo.id == id

  handleUpdate: ->
    self = @
    $('body').on 'click', ".set-cover[data-album-id='#{@album.id}']", ->
      photo = self._find($(@).data().imageId)
      data = {album: {cover_id: photo.id } }
      $.ajax
        url: "/admin/albums/#{self.album.id}"
        type: 'PUT'
        data: data          
        dataType: 'json'
      self.$modalOpener.closest('.template')
      .find('.thumbnail img').attr('src', photo.img)
      self.$modal.modal('hide')
