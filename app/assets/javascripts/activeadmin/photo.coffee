$ ->
  if $('body.admin_photos').length > 0

    if $('body.edit').length > 0

      $(".img-container > img").cropper
        aspectRatio: 16 / 9,
        preview: ".img-preview",
        crop: (e)->
          console.log e.width