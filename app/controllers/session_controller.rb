class SessionController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        
        if user.activated?
        log_in user
        params[:session][:remember_me]=='1' ? remember(user) : forget(user)
        redirect_to user
        else
        message = "Account Not Activated ."
        message +="Check Your email for Activation link"
        flash[:warning] = message
        redirect_to root_url

        #message = "Account not activated. "
        #message += "Check your email for the activation link."
        #flash[:warning] = message
        #redirect_to root_url
        end

      else
      flash.now[:danger] = 'Invalid email/password'  
      render 'new'
      end
  end

  def destroy
    log_out if log_in?
    redirect_to root_url
  end
end
