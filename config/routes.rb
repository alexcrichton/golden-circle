ActionController::Routing::Routes.draw do |map|
  
  #map.resources :proctors
  
  #map.resources :students
  
  #map.resources :teams
  
  map.root :controller => 'sessions', :action => 'new'
end