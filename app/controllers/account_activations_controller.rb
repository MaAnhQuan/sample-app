class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation,
      params[:id])
      activated user
    else
      flash[:danger] = t "invalid_activation"
      redirect_to root_url
    end
  end

  private

  def activated user
    user.activate
    log_in user
    flash[:success] = t "acc_activated"
    redirect_to user
  end
end
