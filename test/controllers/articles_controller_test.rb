require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    log_in_for_test
    @book = books(:one)
    get new_book_article_path(@book.id)
    assert_response :success
  end
end
