class AddIsNonprofitOrganizationToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :nonprofit_organization, :boolean
  end
end
