window.Template = class Template
  prepareMeditableOpts = (self, attrubute)->
    url: self.opts.meditableOpts.url.replace /\:id/, self.resource.id
    dataWrap: self.opts.meditableOpts.dataWrap.replace /@medit/, attrubute

  handleCoverChangealbe = ($template, album)->
    if btn = $template.find('.coverchangeable')
      title = "Изменить абложку альбома #{album.name}"
      new CoverChangeable(album, btn, title)

  constructor: (template, @resourceName, @opts)->
    @opts.meditableOpts ||=
      url: "/admin/#{@resourceName}s/:id"
      dataWrap: "{\"#{@resourceName}\": {\"@medit\": @}}"
    @$template = $(template)
    @resource = JSON.parse(@$template.find('.meta').html())
    @$img = @$template.find('img')
    @$name = @$template.find('.name')
    @$description = @$template.find('.description')
    @$select = @$template.find('select')
    @$destroy = @$template.find('.destroy')
    @backing = new Backing @$template.find('.backing')
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
    @_handleDestroy()
    handleCoverChangealbe(@$template, @resource)

  _handleDestroy: ->
    destroyPath = "/admin/#{@resourceName}s/#{@resource.id}"
    @$destroy.attr('href', destroyPath)
    linkClass = '.destroy'
    @$template.on 'ajax:beforeSend', linkClass, => @backing.show()
    @$template.on 'ajax:success', linkClass, (event, xhr, settings)=>
      if errors = xhr['errors']
        @backing.danger(errors)
      else
        @opts.albumable.remove @resource.id
        @$template.remove()
    @$template.on 'ajax:error', linkClass, => @backing.danger('Что то пошло не так')