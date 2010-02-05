GoldenCircle::Application.routes.draw do |map|

#     Taken out for Heroku
#  resources :uploads, :collection => {:backup => :put, :restore => :get},
#                :member => {:transfer => :get},
#                :only => [:index, :update, :edit]

  resources :schools do
    collection do
      get :show_current
      put :email
      post :valid
    end
  end
  namespace :grading do
    resources :teams do #, :only => [:update, :show] do
      resource  :students#, :only => [:update, :show]
    end
    resource :settings#, :only => [:update, :show]
    controller(:status) { get 'status', :to => :show }
  end
  resources :teams do #, :only => [] do
    get :print, :on => :member
  end

  scope(:path => 'results', :controller => 'results') do
    get 'school', :to => :school
    get 'sweepstakes', :to => :sweepstakes
    get 'individual', :to => :individual
    get 'statistics/:klass', :to => :statistics
  end
  # match '/results/statistics/:klass' => 'results#statistics'
  # statistics '/results/statistics/:klass', :controller => 'results', :action => 'statistics', :conditions => {:method => :get}

  resources :password_resets#, :only => [:new, :create, :edit, :update]
  #logout '/logout', :controller => "school_sessions", :action => "destroy"
  #login '/login', :controller => "school_sessions", :action => "new"
  match 'logout', :to => 'school_sessions#destroy'
  match 'login', :to => 'school_sessions#new'
  resource :school_session#, :only => [:create]

  root :to => "schools#show_current"

end
