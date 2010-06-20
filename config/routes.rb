GoldenCircle::Application.routes.draw do |map|
  
  if Rails.env.production?
    match '*path', :to => redirect { |params| 
      "https://goldencircle.heroku.com/" + params[:path]
    }, :constraints => {:protocol => /http/ }
  end

  resources :schools do
    collection do
      get :show_current
      put :email
      post :valid
    end
    put :admin, :on => :member
  end
  
  namespace :grading do
    resources :teams, :only => [:update, :show] do
      resource  :students, :only => [:update, :show]
    end
    resource :settings, :only => [:update, :show]
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

  resources :password_resets, :only => [:new, :create, :edit, :update]
  get 'logout' => 'school_sessions#destroy'
  get 'login' => 'school_sessions#new'
  post 'login' => 'school_sessions#create'

  root :to => "schools#show_current"

end
