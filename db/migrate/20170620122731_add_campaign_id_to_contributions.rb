class AddCampaignIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :campaign_id, :integer
  end
end
