class Album < ActiveRecord::Base
  include AlbumPhotoCommon
  include AlbumsHierarchy
  has_many :children, class_name: 'Album', foreign_key: 'album_id', dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :parent, foreign_key: 'album_id', class_name: 'Album'
  belongs_to :cover, class_name: 'Photo'

  validates :cover, presence: true, unless: Proc.new {|a| a.cover_id_was.nil? }
  validate :check_cover_between_children
  validate :should_be_near_albums
  validate :move_forbidden

  before_create :clear_hierarchy_catche
  
  scope :deepest, -> { includes(:children).where(children_albums: { id: nil }) }
  scope :with_photos, -> { joins(:photos) }

  def children_photos
    subalbums_ids = hierarchy.map {|data| data[:album][:id] if data[:deepest] }.compact
    Photo.where('album_id in (?)', subalbums_ids)
  end

  def ancestor_for?(album)
    hierarchy.any? {|data| data[:album][:id] == album.id }
  end

  def breadcrumbs
    hierarchy = Album.hierarchy
    @breadcrumbs = []
    current_id = id
    while true
      current = hierarchy.find {|al| al[:album][:id] == current_id }
      @breadcrumbs << current
      parent = hierarchy.find {|al| al[:album][:id] == current[:album][:album_id] }
      break unless parent
      current_id = parent[:album][:id]
    end
    @breadcrumbs.reverse
  end

  def cover
    photo = super
    return photo if photo
    photo = Photo.new(image_file_name: Photo::MISSING_PATH)
    image = photo.image
    def image.url *args
      Photo::MISSING_PATH
    end
    photo
  end

  private

  def should_be_near_albums
    errors.add :album_id, :should_be_near_albums if parent.try(:photos).try(:present?)
  end

  def check_cover_between_children
    if cover_id && children_photos.pluck(:id).exclude?(cover_id)
      errors.add :cover, :between_children 
    end
  end

  def move_forbidden
    super(Album.where(cover_id: children_photos.pluck(:id)))
  end

  def clear_hierarchy_catche
    Album.clear_hierarchy_catche
  end
 
end