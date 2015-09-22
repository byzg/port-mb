window.Template = class Template
  prepareMeditableOpts = (self, attrubute, resourceName)->
    url: self.opts.meditableOpts.url.replace /\:id/, self.resource.id
    dataWrap: self.opts.meditableOpts.dataWrap.replace /@medit/, attrubute

  handleDestroy = ($template, resourceId, resourceName)->
    destroyBtn = $template.find('.destroy')
    destroyPath = "/admin/#{resourceName}s/#{resourceId}"
    destroyBtn.attr('href', destroyPath)
    $template.on 'ajax:success', '.destroy', ->
      $template.remove()

  constructor: (template, @resourceName, @opts)->
    @opts.meditableOpts ||=
      url: "/admin/#{@resourceName}s/:id"
      dataWrap: "{\"photo\": {\"@medit\": @}}"
    @$template = $(template)
    @resource = JSON.parse(@$template.find('.meta').html())
    @$img = @$template.find('img')
    @$name = @$template.find('.name')
    @$description = @$template.find('.description')
    @$select = @$template.find('select#resource_album_id')
    @$destroy = @$template.find('.destroy')
    @fillData()
    @$template.show()

  fillData: ->
    @$img.attr('src', @resource.img)
    @$img.parent().attr('href', @resource.img_link) unless @opts.withoutImgLink
    for medit in ['name', 'description']
      $elem = @["$#{medit}"]
      labelEmpty = $elem.html()
      $elem.html(@resource[medit])
      new mEditable $elem, prepareMeditableOpts(@, medit)              
    @opts.albumable.push @$select, @resource.id, @resource.album_id
    handleDestroy(@$template, @resource.id, @resourceName)