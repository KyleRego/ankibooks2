class SearchController < ApplicationController
  skip_before_action :require_login

  def index # GET /search
    @user = current_user
    @query = search_params[:query]
    public_books = Book.where("is_public = true")
    @books = public_books
  end

  private

  def search_params
    params.permit(:query)
  end
end
