class AddIsLockedAttributeToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :is_locked, :boolean, default: false
  end
end
