require "test_helper"

class BookCreationTest < ActionDispatch::IntegrationTest
  test 'should make a new book if logged in' do
    log_in_for_test(users(:kyle))
    get new_book_path
    assert_difference 'Book.count', 1 do
      post books_path, params: { book: { name: "Book Name",
                                          description: "Book Description" } }
    end
    follow_redirect!
    assert_template :show
    book = users(:kyle).books.where("name = 'Book Name'").first
    assert_equal 'owner', book.role(users(:kyle))
  end

  test 'should not make a new book without a name' do
    log_in_for_test(users(:kyle))
    get new_book_path
    assert_no_difference 'Book.count' do
      post books_path, params: { book: { name: "",
                                          description: "A description" } }
    end
    assert_template 'books/new'
  end

  test 'should not make a new book without a description' do
    log_in_for_test(users(:kyle))
    get new_book_path
    assert_no_difference 'Book.count' do
      post books_path, params: { book: { name: "Valid book name",
                                          description: "" } }
    end
    assert_template 'books/new'
  end

  test 'should display errors when trying to make a new book without a name or description' do
    log_in_for_test(users(:kyle))
    post books_path, params: { book: { name: "", description: "" } }
    assert_template 'books/new'
    assert_match /This form contains 2 errors./, @response.body
    assert_match /Name can&#39;t be blank/, @response.body
    assert_match /Description can&#39;t be blank/, @response.body
  end

  test 'should redirect from new book view if not logged in' do
    get new_book_path
    follow_redirect!
    assert_template '/'
  end

  test 'should not make a new book if not logged in' do
    assert_no_difference 'Book.count' do
      post books_path, params: { book: { name: "Book Name",
                                          description: "Book Description" } }
    end
  end
end
