class Album < ActiveRecord::Base
  has_many :children, class_name: 'Album', foreign_key: 'album_id'
  has_many :photos
  belongs_to :parent, foreign_key: "album_id", class_name: 'Album'
  belongs_to :cover, class_name: 'Photo'

  validates :cover, presence: true
  validate :should_be_near_albums
  
  scope :deepest, -> { includes(:children).where(children_albums: { id: nil }) }
  scope :with_photos, -> { joins(:photos) }

  # def level
  #   result = 1
  #   current_parent = parent
  #   while current_parent
  #     result += 1
  #     current_parent = current_parent.parent
  #   end
  #   result
  # end

  def hierarchy
    Hash[children.map {|album| [album, album.hierarchy]}]
  end

  def self.hierarchy
    Hash[includes(:children).where(album_id: nil).map do |album|
      [album, album.hierarchy]
    end]
  end

  private

  def should_be_near_albums
    errors.add :album_id, :should_be_near_albums if parent.try(:photos).try(:present?)
  end

end