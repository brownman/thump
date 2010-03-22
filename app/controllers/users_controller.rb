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
  
  def set_location
    checkin = current_user.set_location(:lat => params[:lat], :lng => params[:lng], :location => params[:location])
    if checkin.nil?
      latitude, longitude, full_address = params[:lat], params[:lng], "Unknown location"
    else
      l = current_user.location
      latitude, longitude, full_address = l.latitude, l.longitude, l.full_address
    end
    object = {
      :latitude     => latitude, 
      :longitude    => longitude, 
      :full_address => full_address, 
      :user_id      => current_user.id,
      :login        => current_user.login,
      :gravatar_url => current_user.marker.url(:png)
    }
    Pusher['thump-development'].trigger('userCheckedIn', object)
    render :json => object
  end
  
  def with_locations
    collection = []
    [User.all - User.without_locations].flatten.each do |u| 
      collection << {
        :user_id      => u.id, 
        :login        => u.login, 
        :latitude     => u.location.latitude,
        :longitude    => u.location.longitude,
        :full_address => u.location.full_address,
        :gravatar_url => u.marker.url(:png)
      }
    end
    render :json => collection
  end
  
  private
  
  def check_if_current_user
    redirect_to root_url if !current_user || current_user.id != params[:id].to_i
  end
    
end