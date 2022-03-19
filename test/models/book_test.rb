require "test_helper"

class BookTest < ActiveSupport::TestCase
  test 'role should return owner for fixture book 1 and kyle' do
    book = books(:one)
    assert_equal 'owner', book.role(users(:kyle))
  end

  test 'role should return editor for fixture book 1 and user' do
    book = books(:one)
    assert_equal 'editor', book.role(users(:user))
  end

  test 'role should return reader for fixture book 2 and user' do
    book = books(:two)
    assert_equal 'reader', book.role(users(:user))
  end

  test 'owns_book? should return true for fixture book 1 and kyle' do
    assert current_user_for_test.owns_book?(books(:one))
  end

  test 'owns_book? should return false for fixture book 1 and user' do
    refute fixture_user_user.owns_book?(books(:one))
  end

  test 'can_edit? should return true for fixture book 1 and kyle' do
    assert current_user_for_test.can_edit?(books(:one))
  end

  test 'can_edit? should return true for fixture book 1 and user' do
    assert fixture_user_user.can_edit?(books(:one))
  end

  test 'can_edit? should return false for fixture book 2 and user' do
    refute fixture_user_user.can_edit?(books(:two))
  end

end
