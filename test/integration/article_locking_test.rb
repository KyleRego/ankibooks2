require "test_helper"

# this is for testing locking and unlocking articles
class ArticleLockingTest < ActionDispatch::IntegrationTest
  test 'owner of a book should be able to lock and then unlock an article' do
    log_in_for_test(users(:kyle)) # Book one belongs to kyle and their role is owner
    book = books(:one)
    article = articles(:one)
    refute article.is_locked
    post "/books/#{book.id}/articles/#{article.id}/lock"
    article.reload
    assert article.is_locked
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'Article successfully locked.', flash[:success]
    post "/books/#{book.id}/articles/#{article.id}/lock"
    article.reload
    refute article.is_locked
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'Article successfully unlocked.', flash[:success]
  end

  test 'editor of a book should not be able to lock an article' do
    log_in_for_test(users(:user)) # Book one belongs to user and their role is editor
    book = books(:one)
    article = articles(:one)
    refute article.is_locked
    post "/books/#{book.id}/articles/#{article.id}/lock"
    article.reload
    refute article.is_locked
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'You do not have permission to lock/unlock articles of this book.', flash[:error]
  end

  test 'editor of a book should not be able to unlock an article' do
    log_in_for_test(users(:user)) # Book one belongs to user and their role is editor
    book = books(:one)
    article = articles(:two)
    assert article.is_locked
    post "/books/#{book.id}/articles/#{article.id}/lock"
    article.reload
    assert article.is_locked
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'You do not have permission to lock/unlock articles of this book.', flash[:error]
  end

  test 'reader of a book should not be able to lock an article' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    article = articles(:four)
    refute article.is_locked
    post "/books/#{book.id}/articles/#{article.id}/lock"
    article.reload
    refute article.is_locked
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'You do not have permission to lock/unlock articles of this book.', flash[:error]
  end
end
