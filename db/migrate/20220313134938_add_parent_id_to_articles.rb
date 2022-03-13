class AddParentIdToArticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :parent, foreign_key: { to_table: :articles }
  end
end
