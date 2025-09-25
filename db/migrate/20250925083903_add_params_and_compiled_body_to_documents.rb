class AddParamsAndCompiledBodyToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :params, :jsonb, null: false, default: {}
    add_column :documents, :compiled_body, :text
  end
end