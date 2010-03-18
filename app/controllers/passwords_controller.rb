class PasswordsController < ApplicationController
  
  before_filter :check_if_current_user
  
  def edit
    render :layout => logged_in? ? 'app' : 'site'
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = 'Your password was changed'
      redirect_to settings_user_path(current_user)
    else
      flash[:error] = "There's a problem with the password information. Please correct and try again."
      render :action => :edit
    end
  end
  
  private
  
  def check_if_current_user
    if (!current_user || current_user.id != params[:user_id].to_i)
      flash[:error] = "You cannot edit that resource"
      redirect_to root_url
    end
  end
  
end