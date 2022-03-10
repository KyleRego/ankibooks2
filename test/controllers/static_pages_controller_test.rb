require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get "/"
    assert_response :success
  end

  test "should get help" do
    get '/help'
    assert_response :success
  end

  test "should get about" do
    get '/about'
    assert_response :success
    assert_select "h1", "About"
  end
end
