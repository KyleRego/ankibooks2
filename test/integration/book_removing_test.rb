require "test_helper"

class BookRemovingTest < ActionDispatch::IntegrationTest
  test 'should remove a book by destroying the book_user' do
    log_in_for_test(users(:kyle)) # Book three belongs to kyle and their role is reader
    book_user = book_users(:six)
    assert_difference 'BookUser.count', -1 do
      delete "/bookuser/#{book_user.id}"
    end
    follow_redirect!
    assert_equal 'Book successfully removed.', flash[:success]
    assert_template 'users/show'
  end

  test 'should be able to remove a user from a book if you are a owner' do
    log_in_for_test(users(:user))  # Book three belongs to user and their role is owner
    book_user = book_users(:six)   # Book three belongs to kyle and their role is reader
    assert_difference 'BookUser.count', -1 do
      delete "/bookuser/#{book_user.id}"
    end
    follow_redirect!
    assert_equal "Successfully removed the user from the book.", flash[:success]
    assert_template 'users/show'
  end

  test 'should not be able to remove a user from a book if you are not an owner' do
    log_in_for_test(users(:kyle))  # Book three belongs to kyle and their role is reader
    book_user = book_users(:seven) # Book three belongs to user2 and their role is reader
    assert_no_difference 'BookUser.count' do
      delete "/bookuser/#{book_user.id}"
    end
    follow_redirect!
    assert_equal "You cannot remove a user from a book you do not own.", flash[:error]
    assert_template 'users/show'
  end

  test 'should not be able to remove a book from an owner as another owner' do
    log_in_for_test(users(:user)) #  Book three belongs to user and their role is owner
    book_user = book_users(:eight) # Book three belongs to user3 and their role is owner#
    assert_no_difference 'BookUser.count' do
      delete "/bookuser/#{book_user.id}"
    end
    follow_redirect!
    assert_equal 'You cannot remove a book from a user who owns the book.', flash[:error]
    assert_template 'users/show'
  end

  test 'an owner should be able to remove themselves from a book' do
    log_in_for_test(users(:kyle))
    book_user = book_users(:one)
    assert_difference 'BookUser.count', -1 do
      delete "/bookuser/#{book_user.id}"
    end
    follow_redirect!
    assert_equal "Book successfully removed.", flash[:success]
    assert_template 'users/show'
  end
end
