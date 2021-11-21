class ApplicationController < ActionController::Base
  include SessionHelper

  private

  #confirm loged in user
  def logged_in_user
    unless logged_in?
      bybug
      store_location
      flash[:danger] = "Please Log in "
      redirect_to login_url
    end
  end
end
