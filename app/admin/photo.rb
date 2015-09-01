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
  
  form partial: 'form' 

  controller do 
    def create
      super do |format|
        redirect_to edit_admin_photo_path(resource) and return if resource.valid?
      end
    end
  end
  
end
