require "test_helper"

class BookCreationTest < ActionDispatch::IntegrationTest
  test 'should make a new book if logged in' do
    log_in_for_test
    get new_book_path
    assert_difference 'Book.count', 1 do
      post books_path, params: { book: { name: "Book Name",
                                          description: "Book Description" } }
    end
    follow_redirect!
    assert_template :show
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
