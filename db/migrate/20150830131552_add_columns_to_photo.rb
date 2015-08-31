class AddColumnsToPhoto < ActiveRecord::Migration
  def change
    add_reference :photos, :album, index: true
    add_column :photos, :priority, :integer, index: true, default: 0
  end
end
