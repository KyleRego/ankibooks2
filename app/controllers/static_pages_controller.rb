class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def welcome
    @user = current_user
  end

  def help
    @user = current_user
  end

  def about
    @user = current_user
  end
end
