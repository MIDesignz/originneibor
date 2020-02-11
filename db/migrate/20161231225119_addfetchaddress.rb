class Addfetchaddress < ActiveRecord::Migration
  def change
    add_column :campaigns, :fetched_address, :string
    add_column :users, :fetched_address, :string
  end
end
