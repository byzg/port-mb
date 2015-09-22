class Album < ActiveRecord::Base
  has_many :children, class_name: 'Album', foreign_key: 'album_id'
  has_many :photos
  belongs_to :parent, foreign_key: "album_id", class_name: 'Album'
  belongs_to :cover, class_name: 'Photo'

  validates :cover, presence: true
  
  scope :deepest, -> { includes(:children).where(children_albums: { id: nil }) }


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
    Hash[where(album_id: nil).map do |album|
      [album, album.hierarchy]
    end]
  end

end