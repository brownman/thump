ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.root :controller => 'main'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
