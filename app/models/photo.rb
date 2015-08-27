class Photo < ActiveRecord::Base
  has_attached_file(
      :image,
      styles: {medium: '500x500>', small: '50x50>'}
  )
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\Z/
end
