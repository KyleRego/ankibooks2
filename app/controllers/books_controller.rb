class BooksController < ApplicationController
  def new # GET /books/new
    @book = Book.new
  end

  def edit # GET /books/:id/edit
    @user = current_user
    @book = current_user.books.find(params[:id])
  end

  def update # PATCH /books/:id
    user = current_user
    @book = user.books.find(params[:id])
    if !user.owns_book?(@book)
      flash[:error] = 'You cannot update this book.'
      redirect_to user
    elsif user && @book.update(book_params)
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
      book_user = @book.book_users.where(["book_id = ? and user_id = ?", @book.id, user.id]).first
      book_user.role_id = 1
      book_user.save
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
    if user.owns_book?(book)
      book.destroy
      flash[:success] = "Book successfully deleted."
    else
      # raise the same error as if the book couldnt be found
      raise ActiveRecord::RecordNotFound
    end
    redirect_to user, status: :see_other
  end

  def new_book_user # POST /bookuser/new
    user = current_user
    book = user.books.find(book_user_params[:book_id])
    user_book_was_shared_with = User.find_by(name: book_user_params[:name])
    role_id = book_user_params[:role_id].to_i
    if !user_book_was_shared_with
      flash[:error] = "User was not found; book not shared."
    elsif !user.owns_book?(book)
      flash[:error] = "You may not share a book that you do not own."
    elsif user_book_was_shared_with.books.include?(book)
      flash[:error] = "You cannot share a book with a user who already has the book."
    elsif (1..3).cover?(role_id)
      user_book_was_shared_with.books << book
      book_user = book.book_users.where(["book_id = ? and user_id = ?", book.id, user_book_was_shared_with.id]).first
      book_user.role_id = role_id
      book_user.save
      flash[:success] = "Book successfully shared with #{user_book_was_shared_with.name}"
    end
    redirect_to edit_book_path(book)
  end

  private

  def book_params
    params.require(:book).permit(:name, :description)
  end

  def book_user_params
    params.permit(:name, :book_id, :role_id)
  end
end
