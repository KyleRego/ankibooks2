class Article < ApplicationRecord
  belongs_to :book
  has_many :children, class_name: "Article", foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: "Article", foreign_key: 'parent_id', optional: true

  validates :name, presence: true
  validates :content, presence: true

  def subarticles
    subarticles = Article.where(parent_id: self.id)
  end

  def has_children?
    subarticles.count != 0
  end
end
