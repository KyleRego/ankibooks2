class CreateBookUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :book_users do |t|

      t.belongs_to :user
      t.belongs_to :book

      t.timestamps
    end
  end
end
