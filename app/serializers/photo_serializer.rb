class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :album_id, :img, :img_link

  def img
    object.image.url(:medium)
  end

  def img_link
    edit_admin_photo_path(object)
  end
end