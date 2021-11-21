class UsersController < ApplicationController
  
  before_action:logged_in_user , only:[:index ,:edit , :update ,:destroy]
  before_action:correct_user , only:[:edit , :update]
  before_action:admin_user , only: :destroy
  
  
  def index
    @users=User.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.csv {send_data @users.to_csv , filename: "users-#{Date.today}.csv"}
    end

  end

  def show
    @user=User.find_by(params[:id])
  end


  def new
  @user = User.new      
  end

  def create
  @user = User.new(user_params)
    if @user.save
      #@user.send_activation_email
      UserMailer.account_activation(@user).deliver_now
      flash[:info]="Please Check your email to activate your account"
      redirect_to root_url
      #log_in @user
      #flash[:success] = "Welcome to the Sample App!"
      #redirect_to @user
    else
      flash[:message]
      render 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User Deleted"
    redirect_to users_url
  end



  private
  def user_params
    params.require(:user).permit(:name , :email , :password , :password_confirmation)
  end

  #Confirm the Logged in User

  def logged_in_user
    unless log_in?
      store_location
      flash[:danger] = "Please Log in ."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
    
  end
  


end
