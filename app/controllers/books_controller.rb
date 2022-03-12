class BooksController < ApplicationController
  def new # GET /books/new
    ensure_logged_in
    @book = Book.new
  end

  def edit # GET /books/:id/edit
    ensure_logged_in
    @book = Book.find_by(params[:id])
  end

  def update # PATCH /books/:id
    @book = Book.find_by(params[:id])
    user = current_user
    if user && @book.update(book_params)
      redirect_to @book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create # POST /books
    @book = Book.new(book_params)
    user = current_user
    if user && @book.save
      user.books << @book
      flash[:success] = "New book '#{@book.name}' created."
      redirect_to @book
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show # GET /books/:id
    @book = Book.find_by(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:name, :description)
  end
end
