class FaqsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @faqs = Faq.all.group_by(&:faq_category)
  end

  def blogs
    @campaigns = Campaign.active_campaigns
  end

  def view_blog
    @campaign = Campaign.find(params[:id])
  end
end