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
    if user.owns_book?(book)
      begin
        user_book_was_shared_with = User.find_by(name: book_user_params[:name])
        unless user_book_was_shared_with.books.include?(book)
          user_book_was_shared_with.books << book
          role_id = book_user_params[:role_id].to_i
          book_user = book.book_users.where(["book_id = ? and user_id = ?", book.id, user_book_was_shared_with.id]).first
          book_user.role_id = role_id if (1...3).cover?(role_id)
          book_user.save
          flash[:success] = "Book successfully shared with #{user_book_was_shared_with.name}."
        else
          flash[:error] = "You cannot share a book with a user who already has the book."
        end
      rescue
        flash[:error] = "User was not found; book not shared."
      end
    else
      flash[:error] = "You may not share a book that you do not own."
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
