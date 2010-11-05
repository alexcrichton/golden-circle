class Grading::SettingsController < ApplicationController

  authorize_resource

  def show
  end

  def update
    config = GoldenCircle::Configuration.config

    event_date = convert_date(params[:settings], :event_date)
    config.event_date = event_date if event_date
    deadline = convert_date(params[:settings], :deadline)
    config.deadline = deadline if deadline
    config.cost_per_student = params[:settings][:cost_per_student].to_i if params[:settings][:cost_per_student]
    config.cutoff_score = params[:settings][:cutoff_score] if params[:settings][:cutoff_score]

    GoldenCircle::Configuration.save!

    flash[:notice] = 'Settings successfully updated!'

    redirect_to grading_settings_path
  end

  protected

  def convert_date(hash, key)
    args = (1..5).map { |n| val = hash["#{key}(#{n}i)"]; return nil if val.nil?; val}
    Time.local(*args)
  end
end
