class Addclosed < ActiveRecord::Migration
  def change
    add_column :campaigns, :closed_at, :datetime
  end
end
