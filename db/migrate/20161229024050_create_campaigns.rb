class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.string :image_filename
      t.string :image_url
      t.string :video_filename
      t.string :video_url
      t.timestamps null: false
    end
  end
end
