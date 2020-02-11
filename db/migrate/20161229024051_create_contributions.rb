class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :user_id
      t.integer :donation_type
      t.integer :donation_amount
      t.string  :currency_type
      t.timestamps null: false
    end
  end
end
