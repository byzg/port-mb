$ ->  
  if $('body.admin_photos').length > 0

    if $('body.new').length > 0
    
      class PhotoUploader
        constructor: (@form, @opts, @uploadParams = {})->
          if @uploadParams.dropZone?
            $(document).bind 'drop dragover', (e)-> e.preventDefault()
          @photoTemplates = []
          
          @form.fileupload @uploadParams
          .bind 'fileuploadadd', @onAdd
          .bind 'fileuploaddone', @onDone
          .bind 'fileuploadchange', @onChange
          .bind 'fileuploaddrop', @onChange
          .bind 'fileuploadstop', @onAllUploaded

          @opts.addPhotoBtn.click -> $('input[type="file"]').click()
          @uploadParams.dropZone.on 'dragover', @onDragover
          @uploadParams.dropZone.on 'dragleave drop', @onDragleaveDrop
          @uploadParams.dropZone.on 'drop', @onDrop

          @albumable = new Albumable('photo')
          @albumable.global $(@opts.globalAlbumCnt)

        onAdd: (e, data)=>
          @albumable.hideGlobal()
          $photo = @opts.uploadedCnt.find(@opts.uploadedPhotoTemplateSltr)
          clone = $photo.first().clone()
          clone.removeClass 'template'
          @opts.uploadedCnt.append clone
          @photoTemplates.push clone

        onDone: (e, data)=>
          $photoTemplate = @photoTemplates.shift()
          $photoTemplate.find('.meta').html(JSON.stringify(data.result))
          new Template $photoTemplate, 'photo',
            albumable: @albumable
            withoutImgLink: true
          @opts.progressBar.tick()

        onDragover: =>
          @uploadParams.dropZone.removeClass @opts.dropzoneDefaultClass
          @uploadParams.dropZone.addClass @opts.dropzoneDragoverClass

        onDragleaveDrop: =>
          @uploadParams.dropZone.addClass @opts.dropzoneDefaultClass
          @uploadParams.dropZone.removeClass @opts.dropzoneDragoverClass

        onChange: (e, data)=>
          @opts.progressBar.start(data.files.length)
          @uploadParams.dropZone.hide()

        onAllUploaded: (e)=>
          @albumable.showGlobal()
          @uploadParams.dropZone.show()


      $(document).ready ->
        progress = new Progressable($('.progress.progress-striped.active'))
        photoUploader = new PhotoUploader $('form.photo'),
          uploadedCnt: $('.uploaded')
          uploadedPhotoTemplateSltr: '.template'
          addPhotoBtn: $('.fileinput-button')
          dropzoneDefaultClass: 'alert-info',
          dropzoneDragoverClass: 'alert-warning'
          globalAlbumCnt: '.global-album'
          progressBar: progress
        ,
          sequentialUploads: true
          dataType: 'json'
          dropZone: $('.drop-zone')

    if $('body.index').length > 0
      $(document).ready ->
        albumable = new Albumable('photo')
        $('.template').each (_, template)->
          new Template template, 'photo',
            albumable: albumable
            withoutImgLink: true

      