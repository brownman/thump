RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml',                :version => '2.2.19'
  config.gem 'authlogic',           :version => '2.1.3'
  config.gem 'inherited_resources', :version => '0.9.2'
  config.time_zone = 'UTC'
end