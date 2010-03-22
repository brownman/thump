RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml',                :version => '2.2.19'
  config.gem 'authlogic',           :version => '2.1.3'
  config.gem 'inherited_resources', :version => '0.9.2'
  config.gem 'geokit',              :version => '1.5.0'
  config.gem 'pusher',              :version => '0.3.0'
  config.gem 'uuid'
  config.gem 'dragonfly'
  config.time_zone = 'UTC'
  GOOGLE_MAPS_API_KEY = {
    'thump.local'           => 'ABQIAAAAm2KT5pQmVu_d_LD4iTi1hhTqfP3gIxLePz0uARFMhd_RWKvHGBTXHiNUsShqXeA1xZRCYRw62xpOFA',
    'thump.heroku.com'      => 'ABQIAAAAm2KT5pQmVu_d_LD4iTi1hhTUT-E58Qa5sCoosu1bwGIhQafyzxQMkeTaTPOLeTweaYULACBHVQWePQ'
  }

end

Pusher.key = 'c9f08e8c50f6f0cfb136'
