require "test_helper"

class SharingBookTest < ActionDispatch::IntegrationTest
  test 'should share a book from fixture users "kyle" to "user"' do
    log_in_for_test
    book = books(:one)
    get "/books/#{book.id}/edit"
    post bookuser_new_path, params: { book_id: book.id,
                                      name: "user" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "Book successfully shared with user.", flash[:success]
  end

  test 'should not share a book with an invalid username' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: "" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "User was not found; book not shared.", flash[:error]
  end
end
