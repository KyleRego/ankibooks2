class BooksController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def index # GET /books
    @user = current_user
    @books = @user.books
  end

  def new # GET /books/new
    @book = Book.new
  end

  def edit # GET /books/:id/edit
    @user = current_user
    @book = @user.books.find(params[:id])
    unless @user.can_edit?(@book)
      redirect_to books_path
    end
  end

  def update # PATCH /books/:id
    @user = current_user
    @book = @user.books.find(params[:id])
    if !@user.owns_book?(@book)
      flash[:error] = 'You cannot update this book.'
      redirect_to books_path
    elsif @user && @book.update(book_params)
      flash[:success] = "Book successfully updated."
      redirect_to edit_book_path(@book)
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
    @user = current_user
    @book = Book.find_by(id: params[:id])
    if !@user && !@book.is_public
      redirect_to "/"
    elsif !@book.is_public && !@user.books.include?(@book)
      redirect_to "/"
    end
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
    redirect_to books_path, status: :see_other
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

  def destroy_book_user # DELETE /bookuser/:id
    user = current_user
    book_user = BookUser.find_by(id: params[:id])
    user_to_remove = book_user.user
    book_to_remove = book_user.book
    if book_user.user_id == user.id
      book_user.destroy
      flash[:success] = "Book successfully removed."
    elsif user_to_remove.owns_book?(book_to_remove)
      flash[:error] = "You cannot remove a book from a user who owns the book."
    elsif user.owns_book?(book_to_remove)
      book_user.destroy
      flash[:success] = "Successfully removed the user from the book."
    else
      flash[:error] = "You cannot remove a user from a book you do not own."
    end
    redirect_to books_path, status: :see_other
  end

  def switch_is_public # POST /books/:book_id/public
    user = current_user
    book = user.books.find_by(id: params[:book_id])
    if user.owns_book?(book)
      book.is_public = !book.is_public
      book.save
      flash[:success] = "Book successfully made public." if book.is_public
      flash[:success] = "Book successfully made private." unless book.is_public
    else
      flash[:error] = "You must be an owner of the book to change its public status."
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
