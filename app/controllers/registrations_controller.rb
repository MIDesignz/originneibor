class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :address, :password,
                         :password_confirmation, :current_password,
                         :name, :mobile_number)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :address, :password,
                         :password_confirmation, :current_password,
                         :name, :mobile_number)
    end
  end
end
