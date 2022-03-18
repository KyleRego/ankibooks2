require "test_helper"

class BookSharingTest < ActionDispatch::IntegrationTest
  test 'should not share a book with an invalid username' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: "",
                                      role_id: "2" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "User was not found; book not shared.", flash[:error]
  end

  test 'should share the book with fixture user2 as a reader' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: fixture_user_user2.name,
                                      role_id: "3" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'reader', book.role(fixture_user_user2)
  end

  test 'should share the book with fixture user2 as an editor' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: fixture_user_user2.name,
                                      role_id: "2" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'editor', book.role(fixture_user_user2)
  end

  test 'should share the book with fixture user2 as an owner' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: fixture_user_user2.name,
                                      role_id: "1" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'owner', book.role(fixture_user_user2)
  end

  test 'should share the book with fixture user2 as a reader and then fail to reshare as an editor' do
    log_in_for_test
    book = books(:one)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: fixture_user_user2.name,
                                      role_id: "3" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'reader', book.role(fixture_user_user2)
    assert_no_difference 'BookUser.count' do
      post bookuser_new_path, params: { book_id: book.id,
                                        name: fixture_user_user2.name,
                                        role_id: "2" }
    end
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "You cannot share a book with a user who already has the book.", flash[:error]
    assert_equal 'reader', book.role(fixture_user_user2)
  end

  test 'fixture user kyle should not be able to share a book they do not own' do
    log_in_for_test
    book = books(:three)
    assert_equal 'reader', book.role(current_user_for_test)
    post bookuser_new_path, params: { book_id: book.id,
                                      name: fixture_user_user2.name,
                                      role_id: "1" }
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "You may not share a book that you do not own.", flash[:error]
  end
end
