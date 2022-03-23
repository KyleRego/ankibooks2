require "test_helper"

class RemovingImageTest < ActionDispatch::IntegrationTest
  test 'should upload an image and then remove it' do
    log_in_for_test(users(:kyle))
    book = books(:one)
    article = articles(:one)
    post upload_image_path(book, article), params: { article: { image: fixture_file_upload('test_image_one.png') } }
    assert_equal "Image successfully uploaded.", flash[:success]
    image = ActiveStorage::Attachment.last
    post "/books/#{book.id}/articles/#{article.id}/images/#{image.id}/remove"
    assert_equal "Image successfully removed from article.", flash[:success]
  end
end
