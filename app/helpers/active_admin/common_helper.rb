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
    @albums_with_photos_ids ||= Album.with_photos.pluck(:id).uniq
    @albums_with_children_ids ||= Album.with_children.pluck(:id).uniq
    options = (albums_wrapped_list.map do |option|
      option_params = {value: option[:value]}
      if mresource.class == Photo
        option_params[:disabled] = !option[:deepest] || @albums_with_children_ids.include?(mresource.id)
        # option_params[:selected] = option[:value] == mresource.id
      end
      if mresource.class == Album
      end
      content_tag(:option, option[:name], option_params)
    end).join('').html_safe
    select_tag :resource, options, include_blank: true, class: 'pull-left'
  end

end