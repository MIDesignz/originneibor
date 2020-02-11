class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :message_id
      t.integer :campaign_id
      t.datetime :read_at
      t.timestamps null: false
    end

    add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree
    add_index "notifications", ["campaign_id"], name: "index_notifications_on_campaign_id", using: :btree
  end
end
