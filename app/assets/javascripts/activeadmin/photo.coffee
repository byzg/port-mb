$ ->
  if $('body.admin_photos').length > 0
    if $('body.new').length > 0
 
      class PhotoUploader
        handleDestroy = ($photoTemplate, photoId)->
          destroyBtn = $photoTemplate.find('.destroy')
          destroyPath = destroyBtn.attr('href').replace(/(?=.+)\d+/, photoId)
          destroyBtn.attr('href', destroyPath)
          $photoTemplate.on 'ajax:success', '.destroy', ->
            $photoTemplate.remove()


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
          clone.removeClass 'hide'
          @opts.uploadedCnt.append clone
          @photoTemplates.push clone
          for klass in ['.actions', '.name', '.description']
            clone.find(klass).hide()

        onDone: (e, data)=>
          $photoTemplate = @photoTemplates.shift()
          $photoTemplate.find('img').attr 'src', data.result.image_url
          handleDestroy($photoTemplate, data.result.id)
          for klass in ['.actions', '.name', '.description']
            $photoTemplate.find(klass).show()
          for klass in ['.name', '.description']
            new mEditable $photoTemplate.find(klass),
              url: "/admin/photos/#{data.result.id}"
              dataWrap: "{\"photo\": {\"#{klass[1..-1]}\": @}}"
          @opts.progressBar.tick()
          @albumable.push $photoTemplate.find('select'), data.result.id, data.result.album_id

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
          uploadedPhotoTemplateSltr: '.photo.template'
          addPhotoBtn: $('.fileinput-button')
          dropzoneDefaultClass: 'alert-info',
          dropzoneDragoverClass: 'alert-warning'
          globalAlbumCnt: '.global-album'
          progressBar: progress
        ,
          sequentialUploads: true
          dataType: 'json'
          dropZone: $('.drop-zone')
      