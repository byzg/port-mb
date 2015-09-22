window.handleDestroyResource = ($template, resourceId)->
  destroyBtn = $template.find('.destroy')
  destroyPath = destroyBtn.attr('href').replace(/(?=.+)\d+/, resourceId)
  destroyBtn.attr('href', destroyPath)
  $template.on 'ajax:success', '.destroy', ->
    $template.remove()

window.Template = class Template
  prepareMeditableOpts = (self, attrubute)->
    url: self.opts.meditableOpts.url.replace /\:id/, self.resource.id
    dataWrap: self.opts.meditableOpts.dataWrap.replace /@medit/, attrubute

  constructor: (template, @opts)->
    @$template = $(template)
    @resource = JSON.parse(@$template.find('.meta').html())
    @$img = @$template.find('img')
    @$name = @$template.find('.name')
    @$description = @$template.find('.description')
    @$select = @$template.find('select#resource_album_id')
    @fillData()
    @$template.show()

  fillData: ->
    @$img.attr('src', @resource.img)
    for medit in ['name', 'description']
      $elem = @["$#{medit}"]
      labelEmpty = $elem.html()
      $elem.html(@resource[medit])
      new mEditable $elem, prepareMeditableOpts(@, medit)              
    @opts.albumable.push @$select, @resource.id, @resource.album_id
    @opts.handleDestroy(@$template, @resource.id)