class AddVolunteersRequiredToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :volunteers_required, :boolean
  end
end
