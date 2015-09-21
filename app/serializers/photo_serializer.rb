class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :album_id
  attribute :img
  attribute :main_link

  def img
    object.image.url(:medium)
  end

  def main_link
    edit_admin_photo_path(object)
  end
end
