class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.integer :faq_category
      t.string :title
      t.text :description
      t.integer :priority

      t.timestamps null: false
    end
  end
end
