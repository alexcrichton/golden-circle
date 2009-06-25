ActionController::Routing::Routes.draw do |map|

  map.resources :uploads, :collection => {:backup => :put, :restore => :get}, :member => {:transfer => :get}, :only => [:index, :update, :edit]

  map.resources :schools, :collection => {:show_current => :get, :email => :put}

  map.print_team '/print/:id', :controller => 'grading', :action => 'print'
  map.grading_status '/grading', :controller => 'grading', :action => 'status'
  map.grading_config '/grading/config', :controller => 'grading', :action => 'update_configuration', :conditions => {:method => :put}
  map.grading_config '/grading/config', :controller => 'grading', :action => 'config'
  map.grading_teams '/grading/teams/:level', :controller => 'grading', :action => 'update_teams', :conditions => { :method => :put }
  map.grading_teams '/grading/teams/:level', :controller => 'grading', :action => 'teams'
  map.grading_students '/grading/students/:team_id', :controller => 'grading', :action => 'update_students', :conditions => {:method => :put}
  map.grading_students '/grading/students/:team_id', :controller => 'grading', :action => 'students'

  map.statistics '/results/stats', :controller => 'results', :action => 'statistics'
  map.school_results '/results/school', :controller => 'results', :action => 'school'
  map.sweepstakes_results '/results/sweepstakes', :controller => 'results', :action => 'sweepstakes'
  map.individual_results '/results/individual', :controller => 'results', :action => 'individual'

  map.resources :password_resets, :collection => {:current => :get}, :only => [:new, :create, :edit, :update]
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.ssl_prefer '/ssl_prefer', :controller => "school_sessions", :action => "ssl_prefer"
  map.resource :school_session, :only => [:create]

  map.root :controller => "schools", :action => "show_current"

end
