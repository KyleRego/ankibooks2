class UsersController < ApplicationController
  def show # GET /users/:id
    @user = User.find(params[:id])
  end

  def new # GET /users/new
    @user = User.new
  end

  def create # POST /users
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to AnkiBooks"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
