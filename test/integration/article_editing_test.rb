require "test_helper"

class ArticleEditingTest < ActionDispatch::IntegrationTest
  test 'should 1) make a book 2) make an article and 3) edit the article' do
    log_in_for_test
    post books_path, params: { book: { name: "Book Name",
                                          description: "Book Description" } }
    book = Book.last
    post book_articles_path(book.id), params: { article: { name: "Article Name",
                                                          content: "Article Content" } }
    article = Article.last
    assert_equal 'Article Name', article.name
    patch book_article_path(book, article), params: { article: { name: "New article name",
                                                                      content: "New article content" } }
    assert_response :redirect
    follow_redirect!
    assert_template 'books/show'
    assert_equal "Article successfully updated.", flash[:success]
  end

  test 'should not update an article if the update would remove its name' do
    log_in_for_test
    book = books(:one)
    article = articles(:one) # this article belongs to book
    patch book_article_path(book, article), params: { article: { name: "", content: "new content"}}
    assert_template 'articles/edit'
    assert_match /This form contains 1 error/, @response.body
  end

  test 'should not update an article if the update would remove its content' do
    log_in_for_test
    book = books(:one)
    article = articles(:one) # this article belongs to book
    patch book_article_path(book, article), params: { article: { name: "new name", content: ""}}
    assert_template 'articles/edit'
    assert_match /This form contains 1 error/, @response.body
  end
end