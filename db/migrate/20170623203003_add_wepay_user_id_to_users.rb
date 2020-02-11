class AddWepayUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wepay_user_id, :string
  end
end
