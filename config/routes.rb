ActionController::Routing::Routes.draw do |map|

#     Taken out for Heroku
#  map.resources :uploads, :collection => {:backup => :put, :restore => :get},
#                :member => {:transfer => :get},
#                :only => [:index, :update, :edit]

  map.resources :schools, :collection => {:show_current => :get,
                                          :email => :put,
                                          :valid => :post},
                          :member => {:admin => :put}
  map.namespace :grading do |grading|
    grading.resources :teams, :only => [:update, :show] do |team|
      team.resource   :students, :only => [:update, :show]
    end
    grading.resource  :settings, :only => [:update, :show]
    grading.resource  :status, :only => [:show], :controller => 'status', :collection => {:search => :post}
  end
  map.resources :teams, :only => [], :member => {:print => :get}

  map.resource :results, :only => [], :member => {:school => :get, :sweepstakes => :get, :individual => :get}
  map.statistics '/results/statistics/:klass', :controller => 'results', :action => 'statistics', :conditions => {:method => :get}

  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.logout '/logout', :controller => "school_sessions", :action => "destroy"
  map.login '/login', :controller => "school_sessions", :action => "new"
  map.resource :school_session, :only => [:create]

  map.root :controller => "schools", :action => "show_current"

end
