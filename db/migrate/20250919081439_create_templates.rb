class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :visibility
      t.text :description
      t.text :body

      t.timestamps
    end
  end
end
