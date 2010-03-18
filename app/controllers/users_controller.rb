class UsersController < ApplicationController
  inherit_resources
  actions :new, :create
  before_filter :check_if_current_user, :only => :settings
  
  
  def create
    create! do |success,failure|
      success.html{flash[:notice] = "Thanks for signing up"; redirect_to root_url}
      failure.html{flash[:error] = "There's a problem with the signup information. Please correct and try again."; render :action => :new}
    end
  end
  
  def settings
    render :layout => logged_in? ? 'app' : 'site'
  end
  
  private
  
  def check_if_current_user
    redirect_to root_url if !current_user || current_user.id != params[:id].to_i
  end
  
end