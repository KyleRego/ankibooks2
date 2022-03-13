class ArticlesController < ApplicationController
  def new # GET /books/:book_id/articles/new
    @book = current_user.books.find_by(params[:id])
    @article = Article.new
  end

  def new_subarticle # GET /books/:book_id/articles/:parent_id/new
    @book = current_user.books.find_by(params[:book_id])
    @parent_article = @book.articles.find(params[:parent_id])
    @article = Article.new
  end

  def create #  POST /books/:book_id/articles
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.new(article_params)

    if @article.save
      flash[:success] = "Article successfully created."
      redirect_to book_path(@book.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit # GET /books/:book_id/articles/:id/edit
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.find_by(params[:id])
  end

  def update # PATCH /books/:book_id/articles/:id
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.find_by(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article successfully updated."
      redirect_to book_path(@book.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy # DELETE /books/:book_id/articles/:id
    user = current_user
    book = user.books.find_by(params[:book_id])
    article = book.articles.find(params[:id])
    article.destroy
    flash[:success] = "Article successfully deleted."
    redirect_to book_path(book), status: :see_other
  end

  private

  def article_params
    params.require(:article).permit(:name, :content, :parent_id)
  end
end
