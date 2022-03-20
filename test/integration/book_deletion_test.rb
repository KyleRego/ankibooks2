require "test_helper"

class BookDeletionTest < ActionDispatch::IntegrationTest
  test 'should make and then delete a book' do
    log_in_for_test(users(:kyle))
    post books_path, params: { book: { name: "Book Name",
                                      description: "Description" } }
    book = users(:kyle).books.last
    delete book_path(book.id)
    follow_redirect!
    assert_template 'books/index'
    assert_equal "Book successfully deleted.", flash[:success]
  end

  test 'should not be able to delete a book if not logged in' do
    book = books(:one)
    delete book_path(book.id)
    follow_redirect!
    assert_template 'static_pages/welcome'
  end

  test 'should not be able to delete another users book' do
    log_in_for_test(users(:kyle))
    book = books(:three)
    assert_raise ActiveRecord::RecordNotFound do
      delete book_path(book.id)
    end
  end

  test 'logged in user should not be able to delete another users book' do
    log_in_for_test(users(:kyle))
    book = books(:three)
    article = articles(:three)
    assert_raise ActiveRecord::RecordNotFound do
      delete book_article_path(book, article)
    end
  end
end
