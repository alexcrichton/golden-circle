class Grading::ConfigController < ApplicationController

  before_filter :require_admin
  layout 'wide'

  def show
  end

  def update
    event_date = convert_date(params[:settings], :event_date)
    Settings.event_date = event_date if event_date
    deadline = convert_date(params[:settings], :deadline)
    Settings.deadline = deadline if deadline
    Settings.cost_per_student = params[:settings][:cost_per_student].to_i if params[:settings][:cost_per_student]

    flash[:notice] = "Settings successfully updated!"

    redirect_to grading_config_path
  end

  protected

  def convert_date(hash, key)
    args = (1..5).map { |n| val = hash["#{key}(#{n}i)"]; return nil if val.nil?; val}
    Time.zone.local(*args)
  end
end
