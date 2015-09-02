class Photo < ActiveRecord::Base
  RATIOS = { horizontal: '674.5x407', vertical: '674.5x814' }
  has_attached_file(
      :image,
      styles: lambda { |attachment| attachment.instance.styles }
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/

  belongs_to :album

  validate :check_album_level

  def styles
    {medium: '500x500>'}.merge({grid: Photo::RATIOS[orient]})
  end

  def ratio
    width, height = Photo::RATIOS[orient].scan(/\d+.?\d+/).map(&:to_f)
    width / height
  end

  def orient
    image.aspect_ratio > 1 ? :horizontal : :vertical
  end

  private

  def check_album_level
    errors.add :album_id, :should_deepest if album.try(:children).try(:present?)
  end
  
end
