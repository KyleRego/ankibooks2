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
end
