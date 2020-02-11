class Admin::FaqsController < ApplicationController
  def index
    @faqs = Faq.all
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to admin_faqs_path
    else
      render 'new'
    end
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  def update
    @faq = Faq.find(params[:id])
    @faq.update(faq_params)
    redirect_to admin_faqs_path
  end
  def destroy
    @faq = Faq.find(params[:id])
    @faq.delete
    redirect_to admin_faqs_path
  end

  private
  def faq_params
    params.require(:faq).permit(:title, :priority, :faq_category_id, :description)
  end
end