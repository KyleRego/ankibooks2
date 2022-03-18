class AddNotNullConstraintToRoleIdForBookUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :book_users, :role_id, false
  end
end
