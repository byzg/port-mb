class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :message
      t.timestamps null: false
    end
  end
end
