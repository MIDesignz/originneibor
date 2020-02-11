class AddWepayAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wepay_account_status, :boolean, defaults: false
  end
end
