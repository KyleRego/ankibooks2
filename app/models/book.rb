class Book < ApplicationRecord
  has_many :book_users
  has_many :users, through: :book_users
end
