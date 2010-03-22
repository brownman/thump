class User < ActiveRecord::Base
  require 'geokit'
  acts_as_authentic
  belongs_to :location
  after_update :checkout_if_no_location
  
  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end
  
  def set_location(opts={})
    if opts[:location].blank?
      geoloc = Geokit::Geocoders::GoogleGeocoder.geocode(opts[:lat], opts[:lng])
      if geoloc.success?
        loc = Location.find_by_latitude_and_longitude(geoloc.lat, geoloc.lng)
        if loc.nil?
          loc = Location.create(
            :full_address   => geoloc.full_address, 
            :street_number  => geoloc.street_number, 
            :street_name    => geoloc.street_name, 
            :street_address => geoloc.street_address, 
            :city           => geoloc.city, 
            :province       => geoloc.province, 
            :state          => geoloc.state, 
            :zip            => geoloc.zip, 
            :country        => geoloc.country,
            :latitude       => geoloc.lat,
            :longitude      => geoloc.lng        
          )
        end
        self.update_attribute(:location_id, loc.id)
        return loc.id
      else
        return nil
      end
    elsif (opts[:lat].blank? || opts[:lng].blank?)
      geoloc = Geokit::Geocoders::GoogleGeocoder.geocode(opts[:location])
      if geoloc.success?
        loc = Location.find_by_latitude_and_longitude(geoloc.lat, geoloc.lng)
        if loc.nil?
          loc = Location.create(
            :full_address   => geoloc.full_address, 
            :street_number  => geoloc.street_number, 
            :street_name    => geoloc.street_name, 
            :street_address => geoloc.street_address, 
            :city           => geoloc.city, 
            :province       => geoloc.province, 
            :state          => geoloc.state, 
            :zip            => geoloc.zip, 
            :country        => geoloc.country,
            :latitude       => geoloc.lat,
            :longitude      => geoloc.lng        
          )
        end
        self.update_attribute(:location_id, loc.id)
        return loc.id     
      else
        return nil
      end
    else
      raise InvalidArgumentsError
    end
  end
  
  private
  
  def checkout_if_no_location
    Pusher['thump-development'].trigger('userCheckedOut', {:user_id => id, :login => login}) if location.nil?
  end
  
end

class InvalidArgumentsError < StandardError
  def message;"YOU MONKEY";end
end
