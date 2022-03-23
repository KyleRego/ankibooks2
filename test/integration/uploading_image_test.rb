require "test_helper"

class UploadingImageTest < ActionDispatch::IntegrationTest
  test 'should not be able to upload a text file to an article' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    get edit_book_article_path(book, article)
    assert_response :success
    assert_template 'articles/edit'
    post upload_image_path(book, article), params: { article: { image: fixture_file_upload('text_file.txt') } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Only .png and .jpg images may be uploaded.", flash[:error]
  end

  test 'should be able to upload a png file' do
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
  end

  test 'should be able to upload a jpg file' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    get edit_book_article_path(book, article)
    assert_response :success
    assert_template 'articles/edit'
    post upload_image_path(book, article), params: { article: { image: fixture_file_upload('test_image_two.jpg') } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Image successfully uploaded.", flash[:success]
  end

  test 'should get flash error message when not specifying a file to upload' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    get edit_book_article_path(book, article)
    assert_response :success
    assert_template 'articles/edit'
    post upload_image_path(book, article)
    assert_response :redirect
    follow_redirect!
    assert_equal "Something went wrong uploading an image.", flash[:error]
  end
end
