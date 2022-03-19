require "test_helper"

class BookEditingTest < ActionDispatch::IntegrationTest
  test 'should update a book' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book)
    patch book_path(book.id), params: { book: { name: "New book name",
                                                    description: "New description" } }
    follow_redirect!
    assert_template "books/edit"
    assert_equal "Book successfully updated.", flash[:success]
  end

  test 'should not update a book if no new name given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book)
    patch book_path(book.id), params: { book: { name: "", 
                                                description: "Valid description" } }
    assert_template 'books/edit'
    assert_match /This form contains 1 error./, @response.body
  end

  test 'should not update a book if no description given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book)
    patch book_path(book), params: { book: { name: "valid name",
                                                description: "" } }
    assert_template 'books/edit'
    assert_match /This form contains 1 error./, @response.body
  end

  test 'should not update a book if neither name nor description are given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book.id)
    patch book_path(book), params: { book: { name: "", description: "" } }
    assert_template 'books/edit'
    assert_match /This form contains 2 errors./, @response.body
    assert_match /Name can&#39;t be blank/, @response.body
    assert_match /Description can&#39;t be blank/, @response.body
  end

  test 'should not be able to update a book if they are a reader of the book' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    patch book_path(book), params: { book: { name: "new name", description: "new description" } }
    follow_redirect!
    assert_template 'users/show'
    assert_equal "Book 2 Title", book.name
    assert_equal 'You cannot update this book.', flash[:error]
  end

  test 'should not be able to update a book if they are an editor of the book' do
    log_in_for_test(users(:user)) # Book one belongs to user and their role is editor
    book = books(:one)
    patch book_path(book), params: { book: { name: "new name", description: "new description" } }
    follow_redirect!
    assert_template 'users/show'
    assert_equal "Book 1 Title", book.name
    assert_equal 'You cannot update this book.', flash[:error]
  end
end
