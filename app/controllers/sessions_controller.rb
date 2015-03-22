class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user
  def new
    flash[:notice] = 'Login with twitter on topleft to begin or as anonymous'
  end
  def anonymous
    @current_user = User.where(provider: 'non', uid: '0').first
    unless @current_user
      @current_user = User.new(name: 'anonymous', provider: 'non', uid: '0')
      @current_user.save
    end
    session[:user_id] = @current_user.id
    redirect_to sprints_path
  end
  def create
    auth=request.env["omniauth.auth"]
    user=User.find_by_provider_and_uid(auth["provider"],auth["uid"]) ||
      User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to sprints_path
  end
  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Logged out successfully.'
    redirect_to sprints_path
  end
end
