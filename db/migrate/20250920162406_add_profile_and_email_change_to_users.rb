class AddProfileAndEmailChangeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string unless column_exists?(:users, :username)

    add_column :users, :pending_email, :string unless column_exists?(:users, :pending_email)
    add_column :users, :pending_email_token, :string unless column_exists?(:users, :pending_email_token)
    add_column :users, :pending_email_token_sent_at, :datetime unless column_exists?(:users, :pending_email_token_sent_at)

    unless index_exists?(:users, :pending_email_token, unique: true)
      add_index :users, :pending_email_token, unique: true
    end
  end
end
