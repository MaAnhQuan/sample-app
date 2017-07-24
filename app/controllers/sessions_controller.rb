class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      check_activated user
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def not_activated_login
    message = t "acc_not_activated"
    flash[:warning] = message
    redirect_to root_url
  end

  def check_activated user
    user.activated? ? login_success(user) : not_activated_login
  end

  def login_fail
    flash.now[:danger] = t "login_error"
    render :new
  end
end
