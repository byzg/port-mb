class Photo < ActiveRecord::Base
  include AlbumPhotoCommon
  RATIOS = { horizontal: '674x407#', vertical: '674x814#' }
  MISSING_PATH = '/images/grid/missing.png'
  has_attached_file(
      :image,
      styles: lambda { |attachment| attachment.instance.styles },
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/

  belongs_to :album

  validates :image, presence: true
  validate :should_deepest
  validate :move_forbidden

  before_destroy :exist_covered_albums?

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

  def move_forbidden
    super(Album.where(cover_id: id))
  end

  def exist_covered_albums?
    covered = Album.where(cover_id: id)
    errors.add :base, :forbidden_destroy_cover unless result = covered.empty?
    result
  end
  
end
