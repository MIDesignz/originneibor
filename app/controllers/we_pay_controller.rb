require 'wepay'

class WePayController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_wepay_settings, only: [:oauth_callback, :update_uri]

  def oauth_callback
    code = params[:code]; # the code parameter from step 2
    uid = params[:state];
    redirect_uri = ENV['WEPAY_REDIRECT_URL']; # this is the redirect_uri you used in step 1

    # application settings
    client_id = @global_setting.we_pay_client_id
    client_secret = @global_setting.we_pay_client_secret

    # set _use_stage to false for live environments
    wepay = WePay::Client.new(client_id, client_secret, true)

    # create an account for a user
    response = wepay.oauth2_token(code, redirect_uri)

    wepay_user_id = response['user_id']
    access_token = response['access_token']

    # create an account for a user
    account_create_response = wepay.call('/account/create', access_token, {
      :name          => "#{current_user.name}'s Account",
      :description   => 'Merchant Account'
    })

    if access_token.present?
      p "--- #{access_token} IN"
      user = User.find(uid)
      user.update(
                    wepay_account_status: true,
                    wepay_access_token: access_token,
                    wepay_user_id: wepay_user_id,
                    wepay_account_id: account_create_response["account_id"]
                  )
    end

    redirect_to edit_user_registration_path, notice: "WePay account connected!", status: 200
  end

  def update_uri
    client_id = @global_setting.we_pay_client_id
    client_secret = @global_setting.we_pay_client_secret
    account_id = current_user.wepay_account_id
    access_token = current_user.wepay_access_token
    # set _use_stage to false for live environments
    wepay = WePay::Client.new(client_id, client_secret, _use_stage = true)

    # create the withdrawal
    response = wepay.call('/account/get_update_uri', access_token, {
        :account_id     => account_id,
        :mode   => 'iframe',
        :redirect_uri   => 'http://example.com/withdraw/success/'
    })
    current_user.update(wepay_updated_uri: response['uri'])
  end

  def contrib
    @contribution = Contribution.find_by(:wepay_preapproval_id =>params[:preapproval_id])
    @contribution.update_attributes(:status => "In Progress")
    redirect_to contributions_mine_path, notice: "Thank you for Contribution!"
  end

  private
  def load_wepay_settings
    @global_setting = GlobalSetting.first
  end
end
