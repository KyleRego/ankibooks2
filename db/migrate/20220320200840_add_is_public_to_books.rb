class AddIsPublicToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :is_public, :boolean, default: false
  end
end
