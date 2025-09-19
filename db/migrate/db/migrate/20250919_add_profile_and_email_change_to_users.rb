class AddProfileAndEmailChangeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string

    # E-Mail-Änderungs-Flow
    add_column :users, :pending_email, :string
    add_column :users, :pending_email_token, :string
    add_column :users, :pending_email_token_sent_at, :datetime
    add_index  :users, :pending_email_token, unique: true
  end
end
