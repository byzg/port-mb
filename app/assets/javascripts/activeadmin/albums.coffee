$ ->  
  if $('body.admin_albums').length > 0
    if $('body.index').length > 0
      $(document).ready ->
        albumable = new Albumable('photo')
        $('.template').each (_, template)->
          new Template template,
            meditableOpts:
              url: "/admin/photos/:id"
              dataWrap: "{\"photo\": {\"@medit\": @}}"
            handleDestroy: handleDestroyResource
            albumable: albumable
