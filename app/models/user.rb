require 'tempfile'

class User < ActiveRecord::Base

  class Tempfile < ::Tempfile
    # Replaces Tempfile's +make_tmpname+ with one that honors file extensions.
    def make_tmpname(basename, n)
      extension = File.extname(basename)
      sprintf("%s,%d,%d%s", File.basename(basename, extension), $$, n, extension)
    end
  end

  require 'md5'
  require 'geokit'
  acts_as_authentic
  belongs_to :location
  after_update :checkout_if_no_location
  named_scope :without_locations, :conditions => {:location_id => nil}
  image_accessor :marker
  before_create :generate_marker, :if => :development_environment?
  
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
  
  def gravatar_url
    "http://www.gravatar.com/avatar/" + MD5::md5(email.downcase).to_s + ".jpg?s=36"
  end
  
  private
  
  def development_environment?
    RAILS_ENV == "development"
  end
  
  def generate_marker
    tmpfile = Tempfile.new([(RAILS_ROOT+"/tmp/"+ UUID.generate), "png"].compact.join("."))
    tmpfile.binmode
    `convert #{gravatar_url} \
              -bordercolor white  -border 6 \
              -bordercolor grey60 -border 1 \
              -background  none   -rotate 6 \
              -background  black  \\( +clone -shadow 60x4+4+4 \\) +swap \
              -background  none   -flatten \
              #{tmpfile.path}`
    self.marker = File.open(tmpfile.path)
  end
  
  def checkout_if_no_location
    Pusher['thump-'+RAILS_ENV].trigger('userCheckedOut', {:user_id => id, :login => login}) if location.nil?
  end    
  
end

class InvalidArgumentsError < StandardError
  def message;"YOU MONKEY";end
end
