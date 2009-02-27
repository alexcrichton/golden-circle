class PasswordResetsController < ApplicationController

  before_filter :require_no_school, :only => [:create, :new]
  before_filter :load_school_using_perishable_token, :only => [:edit, :update]
  before_filter :require_school, :only => [:current]

  def new
  end

  def create
    @school = School.find_by_email(params[:email])
    if @school
      @school.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
      redirect_to login_path
    else
      flash[:error] = "No user was found with that email address"
      render :action => :new
    end
  end

  def current
    @school = current_school
    @school.reset_perishable_token!
    params[:id] = @school.perishable_token
    render :action => :edit
  end

  def edit
  end

  def update
    @school.password = params[:school][:password]
    @school.password_confirmation = params[:school][:password_confirmation]
    @school.perishable_token = ""
    if @school.save
      flash[:notice] = "Password successfully updated"
      redirect_to @school
    else
      render :action => :edit
    end
  end

  private

  def load_school_using_perishable_token
    @school = School.find_using_perishable_token(params[:id])
    unless @school
      flash[:error] = "We're sorry, but we could not locate your account. " +
              "If you are having issues try copying and pasting the URL " +
              "from your email into your browser or restarting the " +
              "reset password process."
      redirect_to login_path
    end
  end
end
