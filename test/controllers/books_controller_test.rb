require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    log_in_for_test
    get new_book_path
    assert_response :success
  end

  test 'should get edit' do
    log_in_for_test
    book = books(:one)
    get edit_book_path(book.id)
    assert_response :success
  end

  test 'should redirect if trying to access edit book view not logged in' do
    book = books(:one)
    get edit_book_path(book.id)
    assert_response :redirect
  end
end
