class Album < ActiveRecord::Base
  include AlbumPhotoCommon
  include AlbumsHierarchy
  has_many :children, class_name: 'Album', foreign_key: 'album_id', dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :parent, foreign_key: 'album_id', class_name: 'Album'
  belongs_to :cover, class_name: 'Photo'

  validates :cover, presence: true, unless: Proc.new {|a| cover_id_was.nil? }
  validate :check_cover_between_children
  validate :should_be_near_albums
  
  scope :deepest, -> { includes(:children).where(children_albums: { id: nil }) }
  scope :with_photos, -> { joins(:photos) }

  def children_photos
    subalbums_ids = hierarchy.map {|data| data[:album]['id'] if data[:deepest] }.compact
    Photo.where('id in (?)', subalbums_ids)
  end

  private

  def should_be_near_albums
    errors.add :album_id, :should_be_near_albums if parent.try(:photos).try(:present?)
  end

  def check_cover_between_children
    
  end

end