class Add < ActiveRecord::Migration
  def change
    add_column :campaigns, :address, :string
    add_column :users, :address, :string
  end
end
