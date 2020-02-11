class AddStatusAndPreApprovalUrlToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :status, :string , :default => "Pending"
    add_column :contributions, :preapproval_url, :string
  end
end
