require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "parent fixture articles have children and child fixture article does not" do
    assert articles(:one).has_children?
    assert articles(:two).has_children?
    refute articles(:six).has_children?
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

  test 'anki deck title should be article name for top level article' do
    article = articles(:one)
    assert_equal "AnkiBooks::Fixture Article 1", article.anki_deck_title
  end

  test 'anki deck title should combine parent and child names' do
    article = articles(:two)
    assert_equal 'AnkiBooks::Fixture Article 1::Fixture Article 2', article.anki_deck_title
  end

  test 'anki deck title should combine three article names' do
    article = articles(:six)
    assert_equal 'AnkiBooks::Fixture Article 1::Fixture Article 2::Fixture Article 6', article.anki_deck_title
  end
end
