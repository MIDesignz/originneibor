class AlterFaqCategoryToFaqCategoryIdInFaqs < ActiveRecord::Migration
  def change
    rename_column :faqs, :faq_category, :faq_category_id
  end
end
