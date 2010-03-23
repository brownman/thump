class UsersController < ApplicationController
  inherit_resources
  actions :new, :create, :show
  before_filter :check_if_current_user, :only => :settings
  
  def create
    create! do |success,failure|
      success.html{flash[:notice] = "Thanks for signing up"; redirect_to root_url}
      failure.html{flash[:error] = "There's a problem with the signup information. Please correct and try again."; render :action => :new}
    end
  end
  
  def show
    @user = User.find(params[:id])
    render :layout => false
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
      :gravatar_url => RAILS_ENV == "development" ? current_user.marker.url(:png) : current_user.gravatar_url
    }
    Pusher['thump-'+RAILS_ENV].trigger('userCheckedIn', object)
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
        :gravatar_url => RAILS_ENV == "development" ? u.marker.url(:png) : u.gravatar_url
      }
    end
    render :json => collection
  end
  
  def message
    current_user.update_attribute(:message, params[:message])
    object = {
      :latitude     => current_user.location.latitude  || nil, 
      :longitude    => current_user.location.longitude || nil, 
      :full_address => current_user.location.full_address || nil, 
      :user_id      => current_user.id,
      :login        => current_user.login,
      :gravatar_url => RAILS_ENV == "development" ? current_user.marker.url(:png) : current_user.gravatar_url,
      :message      => params[:message]
    }
    unless params[:to_user_id].blank?
      to_user = User.find(params[:to_user_id])
      object = object.merge({:to_user_id => to_user.id, :to_user_login => to_user.login}) unless to_user.nil?
    end
    Pusher['thump-'+RAILS_ENV].trigger('messageBroadcast', object)
    render :json => {:object => object}
  end
  
  private
  
  def check_if_current_user
    redirect_to root_url if !current_user || current_user.id != params[:id].to_i
  end
    
end