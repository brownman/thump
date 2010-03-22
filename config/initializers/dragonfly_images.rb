require 'dragonfly'

# Configuration
app = Dragonfly::App[:images]
app.configure_with(Dragonfly::RMagickConfiguration)
app.configure do |c|
  c.log = RAILS_DEFAULT_LOGGER
  c.datastore.configure do |d|
    d.root_path = "#{Rails.root}/public/system/dragonfly/#{Rails.env}"
  end
  c.url_handler.configure do |u|
    u.secret = 'ebfcb2bcfa4e1b224071f0fec63eacd2da6dd93a'
    u.path_prefix = '/media'
  end
  
  if Rails.env == 'production'
    c.datastore = Dragonfly::DataStorage::S3DataStore.new
    c.datastore.configure do |d|
      d.bucket_name = 'thump_production'
      d.access_key_id = ENV['S3_KEY'] || raise("ENV variable 'S3_KEY' needs to be set")
      d.secret_access_key = ENV['S3_SECRET'] || raise("ENV variable 'S3_SECRET' needs to be set")
    end
  # and filesystem for other environments
  else
    c.datastore.configure do |d|
      d.root_path = "#{Rails.root}/public/system/dragonfly/#{Rails.env}"
    end
  end
  
  
end

# Extend ActiveRecord
# This allows you to use e.g.
#   image_accessor :my_attribute
# in your models.
ActiveRecord::Base.extend Dragonfly::ActiveRecordExtensions
ActiveRecord::Base.register_dragonfly_app(:image, Dragonfly::App[:images])

# Add the Dragonfly App to the middleware stack
ActionController::Dispatcher.middleware.insert_after ActionController::Failsafe, Dragonfly::Middleware, :images

# # UNCOMMENT THIS IF YOU WANT TO CACHE REQUESTS WITH Rack::Cache, and add the line
# #   config.gem 'rack-cache', :lib => 'rack/cache'
# # to environment.rb
# require 'rack/cache'
# ActionController::Dispatcher.middleware.insert_before Dragonfly::Middleware, Rack::Cache, {
#   :verbose     => true,
#   :metastore   => "file:#{Rails.root}/tmp/dragonfly/cache/meta",
#   :entitystore => "file:#{Rails.root}/tmp/dragonfly/cache/body"
# }
