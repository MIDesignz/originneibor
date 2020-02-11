class Admin::CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :approve, :reject, :mark_as_featured]

  def index
    @campaigns = Campaign.all
  end

  def featured_campaigns
    @campaigns = Campaign.featured_campaigns
  end

  def show
  end

  def edit
  end

  def update
    @campaign.update(cam_params)
    redirect_to admin_campaign_path(@campaign), notice: "Campaign has been updated"
  end

  def destroy
    @campaign.delete
    redirect_to admin_campaigns_path, notice: "Campaign has been deleted"
  end

  def approve
    @campaign.update(status: 1)
    redirect_to admin_campaign_path(@campaign), notice: "Campaign has been approved"
  end

  def reject
    @campaign.update(status: 2)
    redirect_to admin_campaign_path(@campaign), notice: "Campaign has been rejected"
  end

  def mark_as_featured
    featured_status = @campaign.is_featured? ? false : true
    @campaign.update(is_featured: featured_status)
  end

  private

  def cam_params
    params.require(:campaign).permit(:name, :address, :description,
                                      :avatar, :user_id, :street_1,
                                      :street_2, :city, :state,
                                      :zipcode, :nonprofit_organization,
                                      :latitude, :longitude, :volunteers_required, :youtube_link)
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end
end