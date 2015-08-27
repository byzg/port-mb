class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.text :description
      t.timestamps
    end
    add_attachment :photos, :image
  end

  def self.down
    drop_table :photos
  end
end
