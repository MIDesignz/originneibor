class AddStreet1AndStreet2AndCityAndStateAndZipCodeAndLatitudeAndLongitudeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :street_1, :string
    add_column :campaigns, :street_2, :string
    add_column :campaigns, :city, :string
    add_column :campaigns, :state, :string
    remove_column :campaigns, :address
  end
end
