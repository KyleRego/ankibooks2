class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def welcome
    if current_user
      redirect_to "/users/#{current_user.id}"
    end
  end

  def help
  end

  def about
  end
end
