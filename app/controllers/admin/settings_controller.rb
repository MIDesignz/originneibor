class Admin::SettingsController < ApplicationController
  def smtp_settings
  end

  def payment_settings
    @global_setting = GlobalSetting.first
  end

  def update_payment_settings
    @global_setting = GlobalSetting.first.update(global_setting_params)
    redirect_to admin_payment_settings_path, notice: "Settings has been updated"
  end

  def other_settings
  end
  private

  def global_setting_params
    params.require(:global_setting).permit(:we_pay_client_id, :we_pay_client_secret, :commission_rate, :campaigns_require_approval)
  end
end