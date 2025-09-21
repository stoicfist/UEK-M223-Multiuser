class ChangeUsersRoleToEnum < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :role, :string, null: false, default: "user"
    add_index :users, :role
  end

  def down
    remove_index :users, :role
    change_column :users, :role, :string, null: true
  end
end
