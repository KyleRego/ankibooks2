require "test_helper"

class BookEditingTest < ActionDispatch::IntegrationTest
  test 'should edit a book' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book.id)
    patch book_path(book.id), params: { book: { name: "New book name",
                                                    description: "New description" } }
    follow_redirect!
    assert_template "books/show"
    assert_equal "Book successfully updated.", flash[:success]
  end

  test 'should not edit a book if no new name given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book.id)
    patch book_path(book.id), params: { book: { name: "", 
                                                description: "Valid description" } }
    assert_template 'books/edit'
    assert_match /This form contains 1 error./, @response.body
  end

  test 'should not edit a book if no description given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book.id)
    patch book_path(book.id), params: { book: { name: "valid name",
                                                description: "" } }
    assert_template 'books/edit'
    assert_match /This form contains 1 error./, @response.body
  end

  test 'should not edit a book if neither name nor description are given' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book.id)
    patch book_path(book.id), params: { book: { name: "", description: "" } }
    assert_template 'books/edit'
    assert_match /This form contains 2 errors./, @response.body
    assert_match /Name can&#39;t be blank/, @response.body
    assert_match /Description can&#39;t be blank/, @response.body
  end
end
