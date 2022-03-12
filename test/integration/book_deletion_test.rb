require "test_helper"

class BookDeletionTest < ActionDispatch::IntegrationTest
  test 'should make and then delete a book' do
    log_in_for_test
    post books_path, params: { book: { name: "Book Name",
                                      description: "Description" } }
    book = current_user_for_test.books.last
    delete book_path(book.id)
    follow_redirect!
    assert_template 'users/show'
  end

  test 'should not be able to delete a book if not logged in' do
    book = books(:one)
    delete book_path(book.id)
    follow_redirect!
    assert_template 'static_pages/welcome'
  end

  test 'should not be able to delete another users book' do
    log_in_for_test
    book = books(:book_three)
    assert_raise ActiveRecord::RecordNotFound do
      delete book_path(book.id)
    end
  end
end
