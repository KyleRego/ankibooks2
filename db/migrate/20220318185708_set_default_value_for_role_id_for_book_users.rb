class SetDefaultValueForRoleIdForBookUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :book_users, :role_id, 3
  end
end
