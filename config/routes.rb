ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.root :controller => 'main'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
