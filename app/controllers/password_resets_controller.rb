class PasswordResetsController < ApplicationController

  before_filter :load_school_using_perishable_token, :only => [:edit, :update]
  before_filter { |c| c.unauthorized! if c.cannot? :reset, 'password' }

  layout 'wide'

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

  def edit
  end

  def update
    if @school.update_attributes(params[:school].slice(:password, :password_confirmation))
      flash[:notice] = "Password successfully updated"
      redirect_to @school
    else
      render :action => 'edit'
    end
  end

  private

  def load_school_using_perishable_token
    @school = School.find_using_perishable_token(params[:id])
    if @school.nil?
      flash[:error] = "We're sorry, but we could not locate your account. " +
              "If you are having issues try copying and pasting the URL " +
              "from your email into your browser or restarting the " +
              "reset password process."
      return redirect_to(login_path)
    end
  end
end
