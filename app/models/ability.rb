class Ability
  include CanCan::Ability
  
  def initialize school
    # We want the index action limited on looking at schools
    aliased_actions.delete :read
    alias_action :show, :show_current, :to => :read
    alias_action :valid, :to => :validate

    config = GoldenCircle::Configuration.config

    if config.deadline.blank? || Time.now < config.deadline
      can :create, School 
    end
    can :validate, School

    if school.nil?
      # No more permissions
    elsif school.admin
      can :manage, :all
    else
      can [:read, :update], School, :id => school.id
      if config.event_date.blank? || Time.now > config.event_date
        can :read, 'results'
      end
    end
  end
end
