require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test 'search should return all public books' do
    get "/search", params: { query: '' }
    assert_response :success
    assert_template 'search/index'
    assert_includes @response.body, "Book 2 Description"
    assert_includes @response.body, "Book 3 Description"
  end
end
