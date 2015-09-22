class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :album_id, :img, :img_link

  def img
    object.cover.image.url(:medium)
  end

  def img_link
    admin_album_path(object)
  end
end
