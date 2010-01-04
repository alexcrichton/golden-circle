ActionController::Routing::Routes.draw do |map|

  map.resources :uploads, :collection => {:backup => :put, :restore => :get},
                :member => {:transfer => :get},
                :only => [:index, :update, :edit]

  map.resources :schools, :collection => {:show_current => :get,
                                          :email => :put,
                                          :valid => :post}
  map.namespace :grading do |grading|
    grading.resources :teams, :only => [:update, :show] do |team|
      team.resource   :students, :only => [:update, :show]
    end
    grading.resource  :config, :only => [:update, :show], :controller => 'config'
    grading.resource  :status, :only => [:show], :controller => 'status'
  end
  map.resources :teams, :only => [], :member => {:print => :get}

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
