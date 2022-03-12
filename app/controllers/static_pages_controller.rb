class StaticPagesController < ApplicationController
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
