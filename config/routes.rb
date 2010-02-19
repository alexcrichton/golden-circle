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
    put :admin, :on => :member
#   map.namespace :grading do |grading|
#     grading.resources :teams, :only => [:update, :show] do |team|
#       team.resource   :students, :only => [:update, :show]
#     end
#     grading.resource  :settings, :only => [:update, :show]
#     grading.resource  :status, :only => [:show], :controller => 'status', :collection => {:search => :post}
# >>>>>>> master
  end
  namespace :grading do
    resources :teams, :only => [:update, :show] do
      resource  :students, :only => [:update, :show]
    end
    resource :settings, :only => [:update, :show]
    # controller(:status) { get 'status', :to => :show, :as => 'status' }
    resource :status do
      post :search
    end
  end
  resources :teams, :only => [] do
    get :print, :on => :member
  end

  scope(:path => 'results', :controller => 'results') do
    get 'school', :to => :school, :as => 'school_results'
    get 'sweepstakes', :to => :sweepstakes, :as => 'sweepstakes_results'
    get 'individual', :to => :individual, :as => 'individual_results'
    get 'statistics/:klass', :to => :statistics, :as => 'statistics'
  end
  # match '/results/statistics/:klass' => 'results#statistics'
  # statistics '/results/statistics/:klass', :controller => 'results', :action => 'statistics', :conditions => {:method => :get}

  resources :password_resets, :only => [:new, :create, :edit, :update]
  #logout '/logout', :controller => "school_sessions", :action => "destroy"
  #login '/login', :controller => "school_sessions", :action => "new"
  match 'logout', :to => 'school_sessions#destroy', :as => 'logout'
  match 'login', :to => 'school_sessions#new', :as => 'login'
  resource :school_session, :only => [:create]

  root :to => "schools#show_current"

end
