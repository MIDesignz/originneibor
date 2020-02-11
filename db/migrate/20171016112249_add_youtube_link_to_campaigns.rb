class AddYoutubeLinkToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :youtube_link, :string
  end
end
