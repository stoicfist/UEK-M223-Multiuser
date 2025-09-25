class ChangeUsersRoleToEnum < ActiveRecord::Migration[8.0]
  def up
    # 1) Default setzen (wirkt für neue Zeilen)
    change_column_default :users, :role, from: nil, to: "user"

    # 2) Bestehende NULLs auffüllen
    execute "UPDATE users SET role = 'user' WHERE role IS NULL"

    # 3) NOT NULL erzwingen
    change_column_null :users, :role, false

    # 4) (Optional) Index
    add_index :users, :role unless index_exists?(:users, :role)
  end

  def down
    remove_index :users, :role if index_exists?(:users, :role)
    change_column_null    :users, :role, true
    change_column_default :users, :role, from: "user", to: nil
  end
end