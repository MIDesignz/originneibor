class SessionsController < Devise::SessionsController
  prepend_before_action :check_captcha, only: [:create]
  def new
    @fail_attempts_count = count = 0
    if params[:user] && !params[:user][:email].blank?
      cookies[:fail_attempts_email] = params[:user][:email]
      cookies[:fail_attempts_count] = cookies[:fail_attempts_count].to_i + 1
      @fail_attempts_count = cookies[:fail_attempts_count]
    end
    super
  end

  def create
    super
  end

  private
    def check_captcha
      @fail_attempts_count = cookies[:fail_attempts_count]
      if @fail_attempts_count.to_i > 9
        unless verify_recaptcha
          self.resource = warden.authenticate!(auth_options)
          resource.validate
          respond_with_navigational(resource) { render :new }
        end
      end 
    end
end
