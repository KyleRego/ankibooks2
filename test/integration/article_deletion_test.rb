require "test_helper"

class ArticleDeletionTest < ActionDispatch::IntegrationTest
  test 'should delete fixture article 1 which has one subarticle' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    assert_difference 'Article.count', -2 do
      delete book_article_path(book, article)
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'books/edit'
    assert_equal 'Article successfully deleted.', flash[:success]
  end

  test 'should delete fixture article 2 which has no subarticles' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:two)
    assert_difference 'Article.count', -1 do
      delete book_article_path(book, article)
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'books/edit'
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

  test 'a reader of a book should not be able to delete an article' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    article = articles(:four)
    assert_raise ActiveRecord::RecordNotFound do
      delete book_article_path(book, article)
    end
  end

  test 'an editor of a book should be able to delete an article' do
    log_in_for_test(users(:user)) # Book one belongs to user and their role is editor
    book = books(:one)
    article = articles(:two)
    assert_difference 'Article.count', -1 do
      delete book_article_path(book, article)
    end
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "Article successfully deleted.", flash[:success]
  end
end
