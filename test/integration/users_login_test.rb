require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:kyle)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to books_path
    follow_redirect!
    assert_template 'books/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "button#logout-button"
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to '/'
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "button#logout-button", count: 0
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: 'aaa' } }
    follow_redirect!
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get '/'
    assert flash.empty?
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
    get '/'
    assert flash.empty?
  end
end
