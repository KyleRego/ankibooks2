class Book < ApplicationRecord
  has_many :book_users
  has_many :users, through: :book_users

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 250 }
end