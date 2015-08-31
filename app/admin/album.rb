ActiveAdmin.register Album do
  # permit_params :image
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil)}
  
  index as: :block do |album|
    a href: edit_admin_album_path(album) do
      span for: album do
        resource_selection_cell album
        img src: album.cover.image.url(:medium)
        div album.name, class: :name
      end
    end
  end
  
  # form do |f|
  #   f.inputs do
  #     f.input :image, as: :file
  #     f.input :description, as: :string
  #   end
  #   f.submit
  # end

end