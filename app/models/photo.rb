class Photo < ActiveRecord::Base
  include AlbumPhotoCommon
  RATIOS = { horizontal: '674x407#', vertical: '674x814#' }
  has_attached_file(
      :image,
      styles: lambda { |attachment| attachment.instance.styles }
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/

  belongs_to :album

  validates :image, presence: true
  validate :should_deepest

  def styles
    {medium: '500x500>'}.merge({grid: Photo::RATIOS[orient]})
  end

  def orient
    if new_record?
      tempfile = image.queued_for_write[:original]
      tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      width, height = [geometry.width.to_i, geometry.height.to_i]
      width > height ? :horizontal : :vertical
    else
      image.aspect_ratio > 1 ? :horizontal : :vertical
    end
  end

  private

  def should_deepest
    errors.add :album_id, :should_deepest if album.try(:children).try(:present?)
  end
  
end
