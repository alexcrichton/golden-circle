ActionController::Routing::Routes.draw do |map|
  
  map.denied '/denied', :controller => 'team_sessions', :action => 'denied'
  
  map.resources :teams
  
  map.logout '/logout', :controller => "team_sessions", :action => "destroy"
  map.login '/login', :controller => "team_sessions", :action => "new"
  map.resource :team_session, :only => [:new, :create, :destroy]
  
  map.root :controller => "team_sessions", :action => "new"
  
end