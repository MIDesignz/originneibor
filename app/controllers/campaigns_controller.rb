class CampaignsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search, :index, :show]
  before_action :load_wepay_settings, only: [:close]

  def index
    redirect_to admin_dashboard_path if user_signed_in? && current_user.is_admin?

    @selected = 5
    @warning = ""

    if current_user.present?
      if current_user.address.present?
        @campaigns = Campaign.active_campaigns.near(current_user.address, @selected, order: false)
      else
        @campaigns = Campaign.active_campaigns
      end
    else
      @campaigns = Campaign.active_campaigns.near(request.remote_ip, @selected, order: false)
    end

    if @campaigns.length == 0
      @warning = "There are no campaigns within #{@selected} miles. Showing those within 20 miles."
      @selected = 20
      @campaigns = Campaign.active_campaigns.near(request.remote_ip, @selected, order: false)
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])

    unless current_user.campaigns.include? @campaign
      redirect_to "/", alert: "You do not have access to that page."
    end
  end

  def close
    @campaign = Campaign.find(params[:id])

    if current_user.campaigns.include? @campaign
      @campaign.update(closed_at: DateTime.current)

      # Charge all the donations that paid money
      wepay = WePay::Client.new(@global_setting.we_pay_client_id, @global_setting.we_pay_client_secret, true)

      @campaign.contributions.each do |c|
        c.user.notifications.create(message_id: 0, campaign: @campaign)

        if c.donation_type == 1
          response = wepay.call('/checkout/create', @campaign.user.wepay_access_token, {
              :account_id         => @campaign.user.wepay_account_id,
              :amount             => c.donation_amount,
              :currency           => 'USD',
              :short_description  => "Payment for #{@campaign.name}",
              :type               => 'donation',
              :payment_method     => {
                      :type       => 'preapproval',
                      :preapproval    => {
                        :id         => c.wepay_preapproval_id
                      }
               }
          })
          Rails.logger.info ">>>>>>#{response.inspect}"
          c.update_attributes(:status => "Paid")
        end
      end


      redirect_to "/campaigns/#{@campaign.id}", notice: "Campaign has ended."
    else
      redirect_to "/", alert: "You do not have access to that page."
    end
  end

  def update
    @campaign = Campaign.find(params[:id])
    @campaign.update(cam_params)
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaign_path(@campaign), notice: "Campaign has been updated" }
      else
        format.html { redirect_to new_campaign_url, alert: @campaign.errors.full_messages.join(", ") }
      end
    end
  end

  def new
  end

  def search
    @selected = (params[:search].present? && params[:search][:distance].present?) ? params[:search][:distance] : 5
    if @selected && @selected.to_i == 0
      @campaigns = Campaign.active_campaigns
    else
      if params[:search].present?
        if !params[:search][:zipcode].blank?
          @campaigns = Campaign.active_campaigns.near( params[:search][:zipcode], params[:search][:distance] )
        end
        if params[:search][:campaign_organization] == "non_profit"
          @campaigns = @campaigns.where(nonprofit_organization: true)
        end
      else
        if current_user.present? 
          @campaigns = Campaign.active_campaigns.near(current_user.address, @selected, order: false)
        else
          @campaigns = Campaign.active_campaigns.near(request.remote_ip, @selected, order: false)
        end
      end
    end
    render action: :index
  end

  def mine
    @campaigns = current_user.campaigns
    render action: :index
  end

  def show
    # redirect_uri = url_for(:controller => 'campaigns', :action => 'payment_success', :id => params[:id])
    @campaign = Campaign.find(params[:id])
    # begin
      # @checkout = @campaign.create_checkout(redirect_uri)
    # rescue Exception => e
      # redirect_to @campaign, alert: e.message
    # end
  end

  def payment_success
    @campaign = Campaign.find(params[:id])
    if !params[:checkout_id]
      return redirect_to @campaign, alert: "Error - Checkout ID is expected"
    end
    if (params['error'] && params['error_description'])
      return redirect_to @campaign, alert: "Error - #{params['error_description']}"
    end
    redirect_to @campaign, notice: "Thanks for the payment! You should receive a confirmation email shortly."
  end

  def show_by_notification
    @campaign = Campaign.find(params[:id])
    @notification = current_user.notifications.where(campaign: @campaign).first
    @notification.update(read_at: DateTime.current) if @notification.present?

    render action: :show
  end

  def create
    campaign = current_user.campaigns.create(cam_params)
    campaign.save
    redirect_to campaign_path(campaign)
  end

  def resubmit_for_approval
    @campaign = Campaign.find(params[:id])
    @campaign.update(status: 0)
    redirect_to campaign_path(@campaign), notice: "Campaign has been resubmited for approval!"
  end

  def create
    @campaign = current_user.campaigns.new(cam_params)
    @campaign.description = cam_params[:description].gsub(/(?:\n\r?|\r\n?)/, '<br>')
    # @campaign.ip_address = Rails.env.development? ? ENV['TEST_IP_ADDRESS'] : request.remote_ip
    # @key = SecureRandom.uuid

    respond_to do |format|
      if @campaign.valid?
        # s3 = Aws::S3::Resource.new(region:'us-west-2')
        # obj = s3.bucket(ENV['AWS_S3_BUCKET']).object("img/campaigns/#{@key}")
        # obj.upload_file(cam_params[:image_filename].path)
        # @campaign.image_filename = @key
        @campaign.save

        format.html { redirect_to campaign_path(@campaign), notice: "Campaign has been created!" }
      else
        format.html { redirect_to new_campaign_url, alert: @campaign.errors.full_messages.join(", ") }
      end
    end
  end

  private

  def cam_params
    params.require(:campaign).permit(:name, :address, :description,
                                      :avatar, :user_id, :street_1,
                                      :street_2, :city, :state,
                                      :zipcode, :nonprofit_organization,
                                      :latitude, :longitude, :volunteers_required, :targeted_amount,
                                      :youtube_link)
  end

  def load_wepay_settings
    @global_setting = GlobalSetting.first
  end
end
