class ChangeAblumCoverId < ActiveRecord::Migration
  def up 
    change_column :albums, :cover_id, :integer, null: true
  end

  def down
    change_column :albums, :cover_id, :integer, null: false
  end
end
