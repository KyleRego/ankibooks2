require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "subarticles method should return the direct children of an article" do
    parent_article = articles(:one)
    child_article = articles(:two)
    assert_equal child_article, parent_article.subarticles.first
  end
end
