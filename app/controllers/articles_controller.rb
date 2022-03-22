class ArticlesController < ApplicationController
  skip_before_action :require_login, only: [:show, :download_deck]

  def new # GET /books/:book_id/articles/new
    @book = current_user.books.find_by(id: params[:book_id])
    @article = Article.new
  end

  def new_subarticle # GET /books/:book_id/articles/:parent_id/new
    @book = current_user.books.find_by(id: params[:book_id])
    @parent_article = @book.articles.find(params[:parent_id])
    @article = Article.new
  end

  def show # GET /books/:book_id/articles/:id
    user = current_user
    @book = Book.find_by(id: params[:book_id])
    @article = @book.articles.find(params[:id])
    if !user && !@book.is_public
      redirect_to "/"
    elsif user && !@book.is_public && !user.books.include?(@book)
      redirect_to "/"
    else
      render json: @article
    end
  end

  def create #  POST /books/:book_id/articles
    user = current_user
    @book = user.books.find_by(id: params[:book_id])
    @article = @book.articles.new(article_params)
    if !user.can_edit?(@book)
      flash[:error] = "You cannot add an article to this book."
      redirect_to books_path
    elsif @article.save
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
    @book = current_user.books.find_by(id: params[:book_id])
    @article = @book.articles.find(params[:id])
    if @article.is_locked
      flash[:error] = 'You cannot edit a locked article.'
      redirect_to edit_book_path(@book)
    end
  end

  def update # PATCH /books/:book_id/articles/:id
    user = current_user
    @book = user.books.find_by(id: params[:book_id])
    @article = @book.articles.find(params[:id])
    if @article.is_locked
      flash[:error] = 'You cannot update a locked article.'
      redirect_to edit_book_path(@book)
    elsif !user.can_edit?(@book)
      flash[:error] = "You cannot update the articles of this book."
      redirect_to books_path
    elsif @article.update(article_params)
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
    if user.can_edit?(book)
      article.destroy
      flash[:success] = "Article successfully deleted."
    else
      # raise the same error as if the book couldnt be found
      raise ActiveRecord::RecordNotFound
    end
    redirect_to edit_book_path(book), status: :see_other
  end

  def switch_is_locked # POST /books/:book_id/articles/:article_id/lock
    user = current_user
    book = user.books.find(params[:book_id])
    article = book.articles.find(params[:article_id])
    if user.owns_book?(book)
      article.is_locked = !article.is_locked
      article.save
      flash[:success] = 'Article successfully locked.' if article.is_locked
      flash[:success] = 'Article successfully unlocked.' unless article.is_locked
    else
      flash[:error] = 'You do not have permission to lock/unlock articles of this book.'
    end
    redirect_to edit_book_path(book), status: :see_other
  end

  def download_deck # GET /books/:book_id/articles/:article_id/download
    user = current_user
    book = Book.find_by(id: params[:book_id])
    article = Article.find_by(id: params[:article_id])
    data_json = article.to_json_data

    if !user && !book.is_public
      flash[:error] = "You cannot download a deck from a private book while not logged in."
      redirect_to "/"
    elsif user && !book.is_public && !user.books.include?(book)
      flash[:error] = "You cannot download a deck from a private book you do not have access to."
      redirect_to "/"
    else
      where_to_put_decks = Rails.root.join('storage', 'tmp_anki_decks')
      deck_filename = `python3 lib/assets/python/make_deck.py '#{data_json}' '#{where_to_put_decks}'`
      file_to_download = File.join(where_to_put_decks, deck_filename)

      if File.exist?(file_to_download)
        send_file file_to_download, filename: deck_filename
      else
        flash[:error] = 'Failed to generate Anki deck.'
        redirect_to book
      end
    end
  end

  private

  def article_params
    params.require(:article).permit(:name, :content, :parent_id)
  end
end
