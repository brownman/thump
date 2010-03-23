ActionController::Routing::Routes.draw do |map|
  map.resources :users, :member => {:settings => :get, :set_location => :post, :message => :post}, :collection => {:with_locations => :get} do |user|
    user.resource :password
  end
  map.resource
  map.resources :user_sessions
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.root :controller => 'main'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
