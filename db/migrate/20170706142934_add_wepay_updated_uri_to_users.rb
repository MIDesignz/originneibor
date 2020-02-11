class AddWepayUpdatedUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wepay_updated_uri, :string
  end
end
