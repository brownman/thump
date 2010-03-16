class UsersController < ApplicationController
  inherit_resources
  actions :new, :create
  
  def create
    create! do |success,failure|
      success.html{ 
        flash[:notice] = "Thanks for signing up"
        redirect_to root_url
      }
    end
  end
  
end