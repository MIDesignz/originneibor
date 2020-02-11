class CreateFaqCategories < ActiveRecord::Migration
  def change
    create_table :faq_categories do |t|
      t.string :title
      t.integer :priority

      t.timestamps null: false
    end
  end
end
