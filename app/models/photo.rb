class Photo < ActiveRecord::Base
  COMPACT_STYLES = {
      horizontal: {
          seven: '528.313x637'
      },
      vertical: {
          seven: '528.313x139'
      }
  }
  has_attached_file(
      :image,
      styles: lambda { |attachment| attachment.instance.styles }
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/

  belongs_to :album

  validate :check_album_level

  # attr_accessor :

  def styles
    {medium: '500x500>', small: '50x50>'}
  end

  private

  def check_album_level
    errors.add :album_id, :should_deepest if album.try(:children).try(:present?)
  end
  
end
