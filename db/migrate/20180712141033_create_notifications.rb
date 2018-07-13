class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :event
      t.integer :user_id

      t.timestamps
    end
  end
end
