class UsersController < ApplicationController
  inherit_resources
  actions :new, :create
  
  def create
    create! do |success,failure|
      success.html{flash[:notice] = "Thanks for signing up"; redirect_to root_url}
      failure.html{flash[:error] = "There's a problem with the signup information. Please correct and try again."; render :action => :new}
    end
  end
  
end