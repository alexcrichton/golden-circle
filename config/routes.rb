ActionController::Routing::Routes.draw do |map|

  map.resources :uploads, :collection => {:backup => :put, :restore => :get}, :member => {:transfer => :get}, :only => [:index, :update, :edit]

  map.resources :schools, :collection => {:show_current => :get,
                                          :email => :put,
                                          :valid_name => :post,
                                          :valid_email => :post}

  map.with_options :controller => 'grading' do |grading|
    grading.with_options :conditions => {:method => :get} do |get|
      get.print_team '/print/:id', :action => 'print'
      get.grading_status '/grading', :action => 'status'
      get.grading_config '/grading/config', :action => 'config'
      get.grading_teams '/grading/teams/:level', :action => 'teams'
      get.grading_students '/grading/students/:team_id', :action => 'students'
    end
    grading.with_options :conditions => {:method => :put} do |put|
      put.grading_config '/grading/config', :action => 'update_configuration'
      put.grading_teams '/grading/teams/:level', :action => 'update_teams'
      put.grading_students '/grading/students/:team_id', :action => 'update_students'
    end
  end

  map.with_options :controller => 'results', :conditions => {:method => :get} do |result|
    result.statistics '/results/stats/:klass', :action => 'statistics'
    result.school_results '/results/school', :action => 'school'
    result.sweepstakes_results '/results/sweepstakes', :action => 'sweepstakes'
    result.individual_results '/results/individual', :action => 'individual'
  end

  map.resources :password_resets, :collection => {:current => :get}, :only => [:new, :create, :edit, :update]
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:create], :collection => {:about_secure => :get, :ssl_prefer => :get}

  map.root :controller => "schools", :action => "show_current"

end
