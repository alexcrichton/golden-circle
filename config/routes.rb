GoldenCircle::Application.routes.draw do |map|
  
  if Rails.env.production?
    # This regex is weird... /http$/ doesn't work though :(
    constraints :protocol => /http[^s]|http$/ do

      # TODO: make this configurable
      match '*p', :to => redirect('https://goldencircle.heroku.com/%{p}')

      # Apparently the above wildcard doesn't match the root url?
      root :to => redirect('https://goldencircle.heroku.com/')
    end
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
  
  get 'teams/:id/print' => 'teams#print'

  scope(:path => 'results', :controller => 'results') do
    get 'school', :to => :school, :as => 'school_results'
    get 'sweepstakes', :to => :sweepstakes, :as => 'sweepstakes_results'
    get 'individual', :to => :individual, :as => 'individual_results'
    get 'statistics/:klass', :to => :statistics, :as => 'statistics'
  end

  devise_for :schools

  root :to => "schools#show_current"

end
