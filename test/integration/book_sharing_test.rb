require "test_helper"

# we also have tests here covering removing the book from a user (not deleting)
class BookSharingTest < ActionDispatch::IntegrationTest
  test 'should not share a book with an invalid username' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: "",
                                      role_id: "2" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "User was not found; book not shared.", flash[:error]
  end

  test 'should share the book with fixture user2 as a reader' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "3" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'reader', book.role(users(:user2))
  end

  test 'should share the book with fixture user2 as an editor' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "2" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'editor', book.role(users(:user2))
  end

  test 'should share the book with fixture user2 as an owner' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "1" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'owner', book.role(users(:user2))
  end

  test 'should share the book with fixture user2 as a reader and then fail to reshare as an editor' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "3" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'reader', book.role(users(:user2))
    assert_no_difference 'BookUser.count' do
      post bookuser_new_path, params: { book_id: book.id,
                                        name: users(:user2).name,
                                        role_id: "2" }
    end
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "You cannot share a book with a user who already has the book.", flash[:error]
    assert_equal 'reader', book.role(users(:user2))
  end

  test 'fixture user kyle should not be able to share a book they do not own' do
    log_in_for_test(users(:kyle))
    book = books(:three)
    assert_equal 'reader', book.role(users(:kyle))
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "1" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "You may not share a book that you do not own.", flash[:error]
  end

  test 'should make a new book and then share it' do
    log_in_for_test(users(:kyle))
    post books_path, params: { book: { name: "Book Name",
                                      description: "Book Description" } }
    book = users(:kyle).books.last
    assert_equal "Book Name", book.name
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user2).name,
                                      role_id: "1" }
    assert_equal "Book successfully shared with user2", flash[:success]
  end

  test 'should make a new book and then share it as user2 to user' do
    log_in_for_test(users(:user2))
    post books_path, params: { book: { name: "My new book",
                                        description: "description" } }
    book = users(:user2).books.last
    assert_equal "My new book", book.name
    post bookuser_new_path, params: { book_id: book.id,
                                      name: users(:user).name,
                                      role_id: "1" }
    assert_equal "Book successfully shared with user", flash[:success]
    assert_includes users(:user).books, book
  end

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
end
