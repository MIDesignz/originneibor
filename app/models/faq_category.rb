class FaqCategory < ActiveRecord::Base
  validates :title, :priority, presence: true
  has_many :faqs
end
