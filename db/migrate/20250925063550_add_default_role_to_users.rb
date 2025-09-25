class AddDefaultRoleToUsers < ActiveRecord::Migration[8.0]
  def up
    change_column_default :users, :role, from: nil, to: "user"
    change_column_null    :users, :role, false, "user"
    add_index :users, :role unless index_exists?(:users, :role)
  end

  def down
    change_column_null    :users, :role, true
    change_column_default :users, :role, from: "user", to: nil
    remove_index :users, :role if index_exists?(:users, :role)
  end
end