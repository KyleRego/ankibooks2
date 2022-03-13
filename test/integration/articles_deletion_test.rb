require "test_helper"

class ArticlesDeletionTest < ActionDispatch::IntegrationTest
  test 'should delete fixture article 1 which has one subarticle' do
    log_in_for_test
    book = books(:one)
    article = articles(:one)
    assert_difference 'Article.count', -2 do
      delete book_article_path(book, article)
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'books/show'
    assert_equal 'Article successfully deleted.', flash[:success]
  end

  test 'should delete fixture article 2 which has no subarticles' do
    log_in_for_test
    book = books(:one)
    article = articles(:two)
    assert_difference 'Article.count', -1 do
      delete book_article_path(book, article)
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'books/show'
    assert_equal 'Article successfully deleted.', flash[:success]
  end

  test 'should not be able to delete the fixture article if not logged in' do
    book = books(:one)
    article = articles(:one)
    assert_no_difference 'Article.count' do
      delete book_article_path(book, article)
    end
    follow_redirect!
    assert_template 'static_pages/welcome'
    assert_equal 'You must be logged in to access this section', flash[:error]
  end

  test 'logged in user should not be able to delete another users book' do
    log_in_for_test
    book = books(:book_three)
    article = articles(:three)
    assert_raise ActiveRecord::RecordNotFound do
      delete book_article_path(book, article)
    end
  end
end
