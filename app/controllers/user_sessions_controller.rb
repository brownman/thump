class UserSessionsController < ApplicationController
  inherit_resources
  actions :new, :create, :destroy
  
  def create
    create! do |success,failure|
      success.html{flash[:notice] = "Hi #{current_user.username}"; redirect_to root_url}
      failure.html{flash[:error] = "There's a problem with the login information. Please correct and try again."; render :action => :new}
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy unless @user_session.nil?
    flash[:notice] = "You're logged out"
    redirect_to root_url
  end
  
end