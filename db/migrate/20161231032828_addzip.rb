class Addzip < ActiveRecord::Migration
  def change
    add_column :campaigns, :zipcode, :string
    add_column :users, :zipcode, :string
  end
end
