class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # before_action :get_ip_address

  before_action :authenticate_user!
  before_action :set_layout
  before_filter :banned?

  layout :set_layout
  def set_layout
    if user_signed_in? && current_user.is_admin?
      'admin'
    else
      'application'
    end
  end

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end

  def get_ip_address
    if current_user.present? && current_user.address.blank?
      if current_user.ip_address != request.remote_ip && !Rails.env.development?
        current_user.update(ip_address: request.remote_ip)
      else
        current_user.update(ip_address: ENV['TEST_IP_ADDRESS']) #Los Angeles Department of Water & Power
      end
    end
  end


  def after_sign_in_path_for(resource)
    cookies.delete :fail_attempts_email
    cookies.delete :fail_attempts_count

    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:notice] = "This account has been suspended for some reason. Please contact our customer support."
      root_path
    elsif current_user.is_admin?
      admin_dashboard_path
    else
      root_url
    end
  end

  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:error] = "This account has been suspended...."
      root_path
    end
  end
end
