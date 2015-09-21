class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :album_id
  attribute :img
  attribute :main_link

  def img
    object.cover.image.url(:medium)
  end

  def main_link
    admin_album_path(object)
  end
end
