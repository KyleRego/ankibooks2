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

  def show # GET /books/:book_id/articles/:id
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.find(params[:id])
    render json: @article
  end

  def create #  POST /books/:book_id/articles
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.new(article_params)

    if @article.save
      flash[:success] = "Article successfully created."
      redirect_to edit_book_path(@book)
    else
      if article_params[:parent_id]
        @parent_article = @book.articles.find(article_params[:parent_id])
        render :new_subarticle, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit # GET /books/:book_id/articles/:id/edit
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.find(params[:id])
  end

  def update # PATCH /books/:book_id/articles/:id
    @book = current_user.books.find_by(params[:book_id])
    @article = @book.articles.find(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article successfully updated."
      redirect_to edit_book_path(@book)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy # DELETE /books/:book_id/articles/:id
    user = current_user
    book = user.books.find(params[:book_id])
    article = book.articles.find(params[:id])
    if user.owns_book?(book)
      article.destroy
      flash[:success] = "Article successfully deleted."
    else
      raise ActiveRecord::RecordNotFound
    end
    redirect_to book_path(book), status: :see_other
  end

  private

  def article_params
    params.require(:article).permit(:name, :content, :parent_id)
  end
end
