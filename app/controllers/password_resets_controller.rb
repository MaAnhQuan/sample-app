class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  attr_reader :user

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if user
      create_success user
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      update_password_empty user
    elsif user.update_attributes user_params
      update_password_success user
    else
      render :edit
    end
  end

  private

  def create_success user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "reset_pass_email_sent"
    redirect_to root_url
  end

  def update_password_empty user
    user.errors.add :password, t("cant_be_empty")
    render :edit
  end

  def update_password_success user
    log_in user
    flash[:success] = t "pass_reset_success"
    redirect_to user
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(:reset,
      params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "pass_reset_expire"
    redirect_to new_password_reset_url
  end
end
