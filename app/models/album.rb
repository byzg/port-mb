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

  def hierarchy(opts = {})
    opts = {without_photos: true}.merge opts
    if opts[:without_photos]
      Hash[children.map {|album| [album, album.hierarchy]}]
    else
      photos
    end
  end

  def self.hierarchy(opts = {})
    opts = {without_photos: true}.merge opts
    Hash[where(album_id: nil).map do |album|
      [album, album.hierarchy(opts)]
    end]
  end

end