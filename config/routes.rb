ActionController::Routing::Routes.draw do |map|

  map.resources :schools, :except => [:edit], :member => {:print => :get}, :collection => {:show_current => :get}
  map.email '/email', :controller => 'schools', :action => 'email', :conditions => { :method => :put }

  map.grading_teams '/grading/teams/:level', :controller => 'grading', :action => 'update_teams', :conditions => { :method => :put }
  map.grading_teams '/grading/teams/:level', :controller => 'grading', :action => 'teams'
  map.grading_students '/grading/students/:team_id', :controller => 'grading', :action => 'update_students', :conditions => {:method => :put}
  map.grading_students '/grading/students/:team_id', :controller => 'grading', :action => 'students'
  map.statistics '/stats', :controller => 'grading', :action => 'statistics'

  map.resources :password_resets, :collection => {:current => :get}
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:create]

  map.root :controller => "schools", :action => "show_current"

end
