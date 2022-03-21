require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    log_in_for_test(users(:kyle))
    get new_book_path
    assert_response :success
  end

  test 'should get edit' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get edit_book_path(book)
    assert_response :success
  end

  test 'should redirect if trying to access edit book view not logged in' do
    book = books(:one)
    get edit_book_path(book)
    assert_response :redirect
  end

  test 'should not allow a reader to access the edit book view' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    get edit_book_path(book)
    assert_response :redirect
  end

  test 'should allow an unlogged in user to read a public book' do
    book = books(:two)
    get book_path(book)
    assert_response :success
  end

  test 'should not allow an unlogged in user to read a private book' do
    book = books(:one)
    get book_path(book)
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/welcome'
  end
end
