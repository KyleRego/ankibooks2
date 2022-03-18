class AddRoleIdToBookUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :book_users, :role_id, :integer
  end
end
