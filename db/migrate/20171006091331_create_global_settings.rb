class CreateGlobalSettings < ActiveRecord::Migration
  def change
    create_table :global_settings do |t|
      t.string :we_pay_client_id
      t.string :we_pay_client_secret
      t.float :commission_rate
      t.boolean :campaigns_require_approval

      t.timestamps null: false
    end
  end
end
