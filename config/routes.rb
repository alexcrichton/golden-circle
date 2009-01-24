ActionController::Routing::Routes.draw do |map|
  
  map.resources :schools, :except => [:edit], :member => {:print => :get}
  map.email '/email', :controller => 'schools', :action => 'email', :conditions => { :method => :put }
  
  map.grading_teams '/grading/teams', :controller => 'grading', :action => 'update_teams', :conditions => { :method => :put }
  map.grading_teams '/grading/teams', :controller => 'grading', :action => 'teams'
  map.grading_students '/grading/students', :controller => 'grading', :action => 'update_students', :conditions => {:method => :put}
  map.grading_students '/grading/students', :controller => 'grading', :action => 'students'
  map.statistics '/stats', :controller => 'grading', :action => 'statistics'
  
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:new, :create, :destroy]
  
  map.root :controller => "school_sessions", :action => "new"
  
end