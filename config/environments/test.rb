config.gem 'rspec',            :version => '1.3.0'
config.gem 'rspec-rails',      :version => '1.3.2'
config.gem 'cucumber',         :version => '0.6.3'
config.gem 'database-cleaner', :version => '0.5.0'
config.gem 'jspec',            :version => '3.3.3'

config.cache_classes = true
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method = :test