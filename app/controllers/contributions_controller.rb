class ContributionsController < ApplicationController
  respond_to :html, :json
  before_action :load_wepay_settings, only: [:create]

  def new
    @campaign = Campaign.find(params[:campaign_id])
    @contribution = Contribution.new
    respond_modal_with @contribution
  end

  def index
    @campaign = Campaign.find(params[:campaign_id])
    @contributions = @campaign.contributions
  end

  def mine
    @contributions = current_user.contributions
    render action: :index
  end

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @contribution = @campaign.contributions.build(con_params)
    @contribution.user_id = current_user.id
    respond_to do |format|
      if @contribution.save
        # Donate through wepay
        if @contribution.donation_type == 1
          wepay = WePay::Client.new(@global_setting.we_pay_client_id, @global_setting.we_pay_client_secret, true)
          response = wepay.call('/preapproval/create', @campaign.user.wepay_access_token, {
              :account_id         => @campaign.user.wepay_account_id,
              :period             => 'once',
              :amount             => @contribution.donation_amount,
              :mode               => 'regular',
              :short_description  => "Donate #{@contribution.donation_amount} to #{@campaign.name}",
              :redirect_uri       => ENV['WEPAY_CONTRIB_REDIRECT_URL']
          })

          p "------- #{response.inspect} --------"
          if response['preapproval_id'].present?
            @contribution.update_attributes(wepay_preapproval_id: response['preapproval_id'],
                                            preapproval_url: response['preapproval_uri'])
          end
          if !response['preapproval_uri'].blank?
            format.html { redirect_to response['preapproval_uri'] }
          else
            format.html { redirect_to campaign_path(@campaign.id), notice: "Error making contribution to #{@campaign.name}" }
          end
        else
          format.html { redirect_to campaign_path(@campaign.id, fb_share: true), notice: "Thanks for your contribution to #{@campaign.name}" }
        end
      else
        format.html { redirect_to campaign_path(@campaign.id), notice: "Error making contribution to #{@campaign.name}" }
      end
    end
  end

  private

  def con_params
    params.require(:contribution).permit(:user_id, :donation_type, :donation_amount,:status,:preapproval_url)
  end

  def load_wepay_settings
    @global_setting = GlobalSetting.first
  end
end
