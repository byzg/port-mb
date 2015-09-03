$ ->
  if $('body.admin_photos').length > 0

    if $('body.edit').length > 0

      class Cropping
        #  не делаять рейбейз этой ветки! если понадобился
        #  кроппер то просто перенести весь необходимый код 
        #  из этой ветки
        constructor: (sltrs)->
          _.each sltrs, (sltr, key)=> @["$#{key}"] = $(sltr)
          @ratio = @$source.closest('form').data('ratio')
          @$source.cropper
            aspectRatio: @ratio
            preview: @$preview.selector
      
      sltrs = 
        source: 'section.img-container > img'
        preview: '.img-preview'
      cropping = new Cropping(sltrs)
      $('.preview-container').find('button').click (e)->
        e.preventDefault()
        $('section.img-container > img').cropper('getCroppedCanvas').toBlob (blob)->
          formData = new FormData()
          formData.append('croppedImage', blob)
          $.ajax '/admin/photos', 
            method: "POST"
            data: formData
            processData: false
            contentType: false