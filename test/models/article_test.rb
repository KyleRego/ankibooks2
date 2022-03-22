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

  test 'article five should return list of two anki notes' do
    article = articles(:five)
    assert_equal ['Here we have an example of an {{c1::Anki note}}', 'How many major types of muscle are there? {{c1::3}}'], article.raw_anki_notes
  end

  test 'article one should return empty list of anki notes' do
    article = articles(:one)
    assert_equal [], article.raw_anki_notes
  end
end
