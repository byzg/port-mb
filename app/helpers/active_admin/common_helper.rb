module ActiveAdmin::CommonHelper 

  def albums_wrapped_list(scope = @hierarchy, deep = '', list = [])
    # Rails.logger.info '##################'
    # Rails.logger.info scope
    # scope.each do |album, hierarchy|
    #   list << {name: (deep + (album.name || "##{album.id}")),
    #            value: album.id,
    #            deepest: hierarchy.empty?
    #           }
    #   list += albums_wrapped_list(hierarchy, deep + '-')
    # end
    # list
  end

  def albumable_select mresource
    # @albumable_select ||= select :resource, :album_id, {include_blank: true}, {class: 'pull-left'} do
    #   albums_wrapped_list.each do |option|
    #     option_params = {value: option[:value]}
    #     case mresource.class
    #       when Photo
    #         option_params[:disabled] = option[:deepest]
    #     end
    #     content_tag(:option, option[:name], option_params)
    #   end
    # end
  end

end