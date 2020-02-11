class Addlatlong < ActiveRecord::Migration
  def change
    add_column :campaigns, :latitude, :float
    add_column :campaigns, :longitude, :float
    add_column :campaigns, :ip_address, :string

    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :ip_address, :string
  end
end
