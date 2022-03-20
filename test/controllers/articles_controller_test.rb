require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    get new_book_article_path(book)
    assert_response :success
  end

  test 'should get a json response from articles#show' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    get book_article_path(book, article)
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal 'Fixture Article 1', json_response["name"]
    assert_equal 'Content of fixture article 1', json_response["content"]
  end

  test 'should not show edit view of a locked article' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:two)
    get edit_book_article_path(book, article)
    assert_response :redirect
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'You cannot edit a locked article.', flash[:error]
  end
end
