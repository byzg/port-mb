ActiveAdmin.register Album do
  permit_params :album_id, :cover_id, :name, :priority
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

end