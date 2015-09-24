module ActiveAdmin::CommonHelper

  def albums_wrapped_list(scope = @hierarchy, deep = '', list = [])
    scope.each do |album, hierarchy|
      list << {name: (deep + (album.name.size == 0 ? "##{album.id}" : album.name)),
               value: album.id,
               deepest: hierarchy.empty?,
               deep: deep.length
              }
      list += albums_wrapped_list(hierarchy, deep + '-')
    end
    list
  end

  def albumable_select mresource
    @albums_with_photos_ids ||= Album.with_photos.pluck(:id).uniq
    @albums_wrapped_list ||= albums_wrapped_list
    options = (@albums_wrapped_list.map do |option|
      option_params = {value: option[:value]}
      if mresource.class == Photo
        option_params[:disabled] = !option[:deepest]
        # option_params[:selected] = option[:value] == mresource.id
      end
      if mresource.class == Album
        @disabling ||= {val: false, deep: nil}
        if option[:value] == mresource.id
          @disabling[:val] = true
          @disabling[:deep] = option[:deep]
        elsif @disabling[:val] && @disabling[:deep] >= option[:deep]
          @disabling[:val] = false
        end
        disabled = @disabling[:val]        
        disabled |= @albums_with_photos_ids.include?(option[:value]) if option[:deepest]
        option_params[:disabled] = disabled
      end
      content_tag(:option, option[:name], option_params)
    end).join('').html_safe
    select_tag :resource, options, include_blank: true, class: 'pull-left'
  end

end