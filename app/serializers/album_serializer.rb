class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :album_id, :img, :img_link

  def img
    if object.cover_id 
      object.cover.image.url(:medium) 
    else
      '/images/grid/missing.png'
    end
  end

  def img_link
    admin_album_path(object)
  end
end
