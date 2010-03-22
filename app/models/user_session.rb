class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_login_or_email
  before_destroy :wipe_user_location
  
  private
  
  def wipe_user_location
    user.update_attribute(:location_id, nil)    
  end
end