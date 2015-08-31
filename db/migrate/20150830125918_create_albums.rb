class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.references :cover, null: false, index: true
      t.references :album, index: true
      t.integer :priority, index: true, default: 0
      t.timestamps null: false
    end
  end
end
