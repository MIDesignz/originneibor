class Admin::FaqCategoriesController < ApplicationController
  def index
    @faq_categories = FaqCategory.all
  end

  def new
    @faq_category = FaqCategory.new
  end

  def create
    @faq_category = FaqCategory.new(faq_category_params)
    if @faq_category.save
      redirect_to admin_faq_categories_path
    else
      render 'new'
    end
  end

  def edit
    @faq_category = FaqCategory.find(params[:id])
  end

  def update
    @faq_category = FaqCategory.find(params[:id])
    @faq_category.update((faq_category_params))
    redirect_to admin_faq_categories_path
  end
  def destroy
    @faq_category = FaqCategory.find(params[:id])
    @faq_category.delete
    redirect_to admin_faq_categories_path
  end

  private
  def faq_category_params
    params.require(:faq_category).permit(:title, :priority)
  end
end