class Faq < ActiveRecord::Base
  validates :faq_category, :title, :description, :priority, presence: true
  belongs_to :faq_category
end
