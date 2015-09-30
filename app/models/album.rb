class Album < ActiveRecord::Base
  include AlbumPhotoCommon
  has_many :children, class_name: 'Album', foreign_key: 'album_id', dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :parent, foreign_key: "album_id", class_name: 'Album'
  belongs_to :cover, class_name: 'Photo'

  validates :cover, presence: true
  validate :should_be_near_albums
  
  scope :deepest, -> { includes(:children).where(children_albums: { id: nil }) }
  scope :with_photos, -> { joins(:photos) }

  def self.hierarchy
    find_children = Proc.new do |scope, album|
      scope.delete(album)
      children = scope.find_all {|al| al.album_id == album.id}
      scope.delete_if {|al| children.map(&:id).include?(al.id) }
      Hash[children.map {|album| [album, find_children.call(scope, album)]}]
    end
    all = Album.select(:id, :album_id, :name)
    Hash[all.where(album_id: nil).map do |album|
      [album, find_children.call(all.to_a, album)]
    end]    
  end

  private

  def should_be_near_albums
    errors.add :album_id, :should_be_near_albums if parent.try(:photos).try(:present?)
  end

end