window.Breadcrumbs = class Breadcrumbs
  constructor: ->
    @list = @_get_list()
    @_paste_links()

  _get_list: ->
    data = JSON.parse $('.breadcrumbs.custom').html()
    _.map data, (pair)->
      id: pair.album.id
      name: pair.album.name

  _paste_links: ->
    _.each @list, (album)->
       album.link = "<a href='/admin/albums/#{album.id}'>#{album.name}</a>"

  draw: ->
    $breadcrumbs = $('#titlebar_left .breadcrumb')
    _.each @list, (album)->
      $breadcrumbs.append $(album.link)
      $breadcrumbs.append $('<span class="breadcrumb_sep">/</span>')
      console.log $breadcrumbs.children()