class Ability
  include CanCan::Ability
  
  def initialize(school)
    clear_aliased_actions

    alias_action :edit, :to => :update
    alias_action :new, :to => :create
    alias_action :show, :to => :read

    alias_action :show_current, :to => :read
    alias_action :valid, :to => :validate
    
    can :create, School do 
      Settings.deadline.blank? || Time.now < Settings.deadline
    end
    can :validate, School
    if school.nil?
      can :login, School
      can :reset, 'password'
    elsif school.admin
      can :manage, :all
      cannot :reset, 'password' # need to be logged out (don't want to mess with other users)
    else
      can :logout, School
      can [:read, :update], school
      can :read, 'results' do
        Settings.event_date.blank? || Time.now > Settings.event_date
      end
    end
  end
end
