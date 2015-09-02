$ ->
  if $('body.admin_photos').length > 0

    if $('body.edit').length > 0

      $("section.img-container > img").cropper
        aspectRatio: 528.313 / 339,
        preview: ".img-preview",
        crop: (e)->
          console.log e.width