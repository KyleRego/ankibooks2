require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "parent fixture article has children and child fixture article does not" do
    assert articles(:one).has_children?
    assert_not articles(:two).has_children?
  end 

  test "subarticles method should return the direct children of an article" do
    parent_article = articles(:one)
    child_article = articles(:two)
    assert_equal child_article, parent_article.subarticles.first
  end
end
