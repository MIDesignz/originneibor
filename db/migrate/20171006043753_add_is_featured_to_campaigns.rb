class AddIsFeaturedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :is_featured, :boolean
  end
end
