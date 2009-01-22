ActionController::Routing::Routes.draw do |map|
  
  map.resources :schools, :only => [:new, :index, :update, :show, :destroy], :member => {:print => :get}
  
  map.namespace :grading do |grading|
    grading.teams '/teams', :controller => 'grading', :action => 'teams'
    grading.students '/students', :controller => 'grading', :action => 'students'
  end
  map.statistics '/stats', :controller => 'grading', :action => 'statistics'
  
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:new, :create, :destroy]
  
  map.root :controller => "school_sessions", :action => "new"
  
end