ActionController::Routing::Routes.draw do |map|
  
  map.resources :schools
  
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:new, :create, :destroy]
  
  map.root :controller => "school_sessions", :action => "new"
  
end