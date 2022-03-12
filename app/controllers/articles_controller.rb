class ArticlesController < ApplicationController
  def new # GET /books/:book_id/articles/new
    @book = current_user.books.find_by(params[:id])
    @article = Article.new
  end
end
