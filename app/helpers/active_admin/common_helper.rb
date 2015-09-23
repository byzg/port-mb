module ActiveAdmin::CommonHelper

  def albums_wrapped_list(scope = @hierarchy, deep = '', list = [])
    scope.each do |album, hierarchy|
      list << {name: (deep + (album.name || "##{album.id}")),
               value: album.id,
               deepest: hierarchy.empty?
              }
      list += albums_wrapped_list(hierarchy, deep + '-')
    end
    list
  end

  def albumable_select mresource
    unless @albumable_select
      options = (albums_wrapped_list.map do |option|
        option_params = {value: option[:value]}
        case mresource.class
          when Photo
            option_params[:disabled] = option[:deepest]
        end
        content_tag(:option, option[:name], option_params)
      end).join('')
      p options
      @albumable_select = select_tag :resource, options.html_safe
    end
    @albumable_select
  end

end