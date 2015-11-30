class Photo < ActiveRecord::Base
  include AlbumPhotoCommon
  RATIOS = { horizontal: '674x407#', vertical: '674x814#' }
  MISSING_PATH = '/images/grid/missing.png'
  MODAL_WEIGHT = 0.5
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
    { medium: '500x500>',
      modal: "#{width * MODAL_WEIGHT}x#{width * MODAL_WEIGHT}>"
    }.merge({grid: Photo::RATIOS[orient]})
  end

  def geometry
    @geometry ||= Paperclip::Geometry.from_file(tempfile)
  end  

  def width
    image.width || (@width ||= geometry.width.to_i)
  end

  def heigth
    image.heigth || (@height ||= geometry.width.to_i)
  end  

  def orient
    if new_record?
      width > height ? :horizontal : :vertical
    else
      image.aspect_ratio > 1 ? :horizontal : :vertical
    end
  end

  def self.refresh(style)
    _count = count
    puts "--- Refresh #{_count} photos for #{style} ---"
    i = 0
    find_each do |photo|
      i += 1
      puts "---- start refresh #{i}/#{_count} photo with ID #{photo.id} ----"
      photo.image.reprocess! style.to_sym
    end  
    puts "--- refresh finished ---"
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

  private
  def tempfile
    @tempfile ||= image.queued_for_write[:original]
  end
  
end
