class Book < ApplicationRecord
  has_many :book_users
  has_many :users, through: :book_users

  has_many :articles

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 250 }

  def top_level_articles
    self.articles.select do |article|
      article.parent_id.nil?
    end
  end
end
