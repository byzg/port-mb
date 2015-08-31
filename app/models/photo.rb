class Photo < ActiveRecord::Base
  has_attached_file(
      :image,
      styles: {medium: '500x500>', small: '50x50>'}
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/

  belongs_to :album

  validate :check_album_level


  private

  def check_album_level
    errors.add :album_id, :should_deepest if album.try(:children).try(:present?)
  end
  
end
