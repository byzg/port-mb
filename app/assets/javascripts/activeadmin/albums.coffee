$ ->  
  if $('body.admin_albums').length > 0
    if $('body.index').length > 0 || $('body.show').length > 0
      $(document).ready ->
        albumable = new Albumable 'album',
          onAfterSelect: -> location.reload()
        $('.template.album').each (_, template)->
          new Template template, 'album',
            albumable: albumable
