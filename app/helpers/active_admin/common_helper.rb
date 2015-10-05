module ActiveAdmin::CommonHelper

  def albums_wrapped_list(hierarchy = @hierarchy, deep = '', list = [])
    hierarchy.map do |struct|
      album = struct[:album]
      {name: ("#{'-' * struct[:deep]}#{album[:name]}"),
       value: album[:id],
       deepest: struct[:deepest],
       deep: struct[:deep]
      }
    end
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

  def template_confirm_message(mresource)
    if defined?(mresource) && mresource.is_a?(Album)
      "Удалить альбом и все вложенные в него альбомы и фото?"
    elsif !defined?(mresource) || mresource.is_a?(Photo)
      "Удалить фото?"
    end
  end

end