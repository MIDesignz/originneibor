class AddTargetedAmountToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :targeted_amount, :integer
  end
end
