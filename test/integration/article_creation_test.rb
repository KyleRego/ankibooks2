require "test_helper"

class ArticleCreationTest < ActionDispatch::IntegrationTest
  test 'should make a book and then an article' do
    log_in_for_test(users(:kyle))
    get new_book_path
    post books_path, params: { book: { name: "new book",
                                      description: "new book description" } }
    book = Book.last
    get new_book_article_path(book.id)
    assert_difference 'Article.count', 1 do 
      post book_articles_path(book.id), params: { article: { name: 'article name',
                                                              content: 'article content' } }
    end
    follow_redirect!
    assert_template 'books/edit'
    assert_equal "Article successfully created.", flash[:success]
  end

  test 'should not make an article if it does not have a name' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    assert_no_difference 'Article.count' do
      post book_articles_path(book.id), params: { article: { name: "",
                                                  content: "article content" } }
    end
    assert_template 'articles/new'
    assert_match /This form contains 1 error./, @response.body
  end

  test 'should not make an article if it does not have content' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    assert_no_difference 'Article.count' do
      post book_articles_path(book.id), params: { article: { name: "name",
                                                  content: "" } }
    end
    assert_template 'articles/new'
    assert_match /This form contains 1 error./, @response.body
  end
  
  test 'should make a subarticle' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    parent_article = articles(:one)
    get "/books/#{book.id}/articles/#{parent_article.id}/new"
    post "/books/#{book.id}/articles", params: { article: { name: "new child article",
                                                            content: "description",
                                                            parent_id: parent_article.id } }
    follow_redirect!
    assert_equal "Article successfully created.", flash[:success]
    assert_template 'books/edit'
  end
  
  test 'should not be able to make an article for a book that doesnt belong to them' do
    log_in_for_test(users(:user2)) # Book 1 does not have a relationship with user2
    book = books(:one)
    assert_raise "NoMethodError" do
      post book_articles_path(book), params: { article: { name: "name",
                                                          content: "content" } }
    end
  end

  test 'should not be able to make an article for a book as a reader of the book' do
    log_in_for_test(users(:user)) # Book two belongs to user and their role is reader
    book = books(:two)
    assert_no_difference 'Article.count' do
      post book_articles_path(book), params: { article: { name: "name",
                                                          content: "content" } }
    end
    assert_equal "You cannot add an article to this book.", flash[:error]
  end
end
