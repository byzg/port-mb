ActiveAdmin.register Photo do
  config.clear_sidebar_sections!
  permit_params :image, :description, :album_id

  index as: :block do |photo|
    a href: edit_admin_photo_path(photo) do
      span for: photo do
        resource_selection_cell photo
        img src: photo.image.url(:medium)
        div photo.description, class: :description
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      if resource.image.exists?
        img src: photo.image.url(:medium)
      else
        f.input :image, as: :file
      end
      f.input :description, as: :string
      f.input :album, as: :select, collection: Album.deepest.pluck(:name, :id)
    end
    actions
  end  
  
end
