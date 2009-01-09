ActionController::Routing::Routes.draw do |map|
  
  map.denied :controller => 'team_sessions', :action => 'denied'
  
  map.resources :teams
  
  map.root :controller => 'team_sessions', :action => 'new'
end