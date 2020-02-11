class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :mark_banned]
  def index
    @users =  if params[:q]
                User.where('name LIKE ? or email LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
              else
                User.all
              end
    # respond_to do |format|
    #   format.html
    #   format.json { render json: UserDatatable.new(view_context) }
    # end
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to admin_users_path, notice: "User has been updated"
  end

  def destroy
    @user.delete
    redirect_to admin_users_path, notice: "User has been deleted"
  end

  def active_users
    @users = User.active_users    
  end

  def banned_users
    @users = User.banned_users    
  end

  def mark_banned
    banned_status = @user.banned? ? false : true
    @user.update(banned: banned_status)
    redirect_to admin_users_path, notice: "User has been #{@user.banned? ? 'banned' : 'active'} now"
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :address, :email, :mobile_number)
  end
end