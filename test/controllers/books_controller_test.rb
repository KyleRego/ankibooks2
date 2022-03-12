require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    log_in_for_test
    get books_new_url
    assert_response :success
  end
end
