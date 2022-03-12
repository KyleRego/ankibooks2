ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as the user kyle from test/fixtures/users.yml
  def log_in_for_test
    user = users(:kyle)
    post login_path, params: { session: { email: user.email,
                                          password: 'password' } }
  end

  def current_user_for_test
    users(:kyle)
  end
end
