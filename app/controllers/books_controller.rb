class BooksController < ApplicationController
  def new # GET /books/new
    @book = Book.new
  end

  def edit # GET /books/:id/edit
    @book = current_user.books.find(params[:id])
  end

  def update # PATCH /books/:id
    user = current_user
    @book = user.books.find(params[:id])
    if user && @book.update(book_params)
      flash[:success] = "Book successfully updated."
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
    @book = current_user.books.find(params[:id])
  end

  def destroy # DELETE /books/:id
    user = current_user
    book = user.books.find(params[:id])
    book.destroy
    flash[:success] = "Book successfully deleted."
    redirect_to user, status: :see_other
  end

  def new_book_user # POST /bookuser/new
    user = current_user
    book = user.books.find(params[:book_id])
    begin
      user_book_was_shared_with = User.find_by(name: params[:name])
      user_book_was_shared_with.books << book
      flash[:success] = "Book successfully shared with #{user_book_was_shared_with.name}."
    rescue
      flash[:error] = "User was not found; book not shared."
    end
    redirect_to edit_book_path(book)
  end

  private

  def book_params
    params.require(:book).permit(:name, :description)
  end
end
