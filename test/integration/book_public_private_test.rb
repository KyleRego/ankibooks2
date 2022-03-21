require "test_helper"

class BookPublicPrivateTest < ActionDispatch::IntegrationTest
  test 'an owner of a book should be able to make a book public and then private' do
    log_in_for_test(users(:kyle)) # Book one belongs to kyle and their role is owner
    book = books(:one)
    refute book.is_public
    post "/books/#{book.id}/public"
    follow_redirect!
    assert_template 'books/edit'
    book.reload
    assert book.is_public
    post "/books/#{book.id}/public"
    follow_redirect!
    assert_template 'books/edit'
    book.reload
    refute book.is_public
  end

  test 'an editor of a book should not be able to make a book public' do
    log_in_for_test(users(:user)) # Book one belongs to user and their role is editor
    book = books(:one)
    refute book.is_public
    post "/books/#{book.id}/public"
    follow_redirect!
    assert_template 'books/edit'
    book.reload
    refute book.is_public
  end

  test 'a reader of a book should not be able to make a book public' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    refute book.is_public
    post "/books/#{book.id}/public"
    follow_redirect!
    follow_redirect!
    assert_template 'books/index'
    book.reload
    refute book.is_public
  end
end
