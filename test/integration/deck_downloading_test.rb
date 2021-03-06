require "test_helper"

class DeckDownloadingTest < ActionDispatch::IntegrationTest
  test 'should download a deck from an owned book with no notes' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    assert_equal 0, article.raw_anki_notes.length
    get books_path(book)
    get "/books/#{book.id}/articles/#{article.id}/download"
    assert_response :success
  end

  test 'should download a deck with 2 notes from a public book' do
    log_in_for_test(users(:kyle))
    book = books(:four)
    article = articles(:five)
    assert_equal 2, article.raw_anki_notes.length
    get books_path(book)
    get "/books/#{book.id}/articles/#{article.id}/download"
    assert_response :success
  end
  
  test 'should not be able to download a deck from a private book not logged in' do
    book = books(:one)
    article = articles(:one)
    get books_path(book)
    get "/books/#{book.id}/articles/#{article.id}/download"
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/welcome'
    assert_equal 'You cannot download a deck from a private book while not logged in.', flash[:error]
  end

  test 'should not be able to download a deck from a private book the user does not have access to' do
    log_in_for_test(users(:user2))
    book = books(:one)
    article = articles(:one)
    get "/books/#{book.id}/articles/#{article.id}/download"
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/welcome'
    assert_equal 'You cannot download a deck from a private book you do not have access to.', flash[:error]
  end

  test 'should upload 2 images to a article and then download its deck' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    get edit_book_article_path(book, article)
    assert_response :success
    assert_template 'articles/edit'
    post upload_image_path(book, article), params: { article: { image: fixture_file_upload('test_image_one.png') } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Image successfully uploaded.", flash[:success]
    post upload_image_path(book, article), params: { article: { image: fixture_file_upload('test_image_two.jpg') } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Image successfully uploaded.", flash[:success]
    get books_path(book)
    assert_response :success

    get "/books/#{book.id}/articles/#{article.id}/download"
    assert_response :success
  end
end
