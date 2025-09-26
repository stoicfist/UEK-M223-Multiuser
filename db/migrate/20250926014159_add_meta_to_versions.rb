class AddMetaToVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :versions, :ip, :string, limit: 45
    add_column :versions, :user_agent, :string
  end
end
