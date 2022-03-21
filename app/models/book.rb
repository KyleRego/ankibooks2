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

  # returns the role (as a string) for the book and user
  def role(user)
    role_id = self.book_users.where("user_id = #{user.id}").first.role_id
    case role_id
    when 1
      'owner'
    when 2
      'editor'
    when 3
      'reader'
    end
  end

  def to_s
    "==Book #{self.id}: name: #{self.name}; description: #{self.description}; is_public: #{self.is_public}=="
  end
end
