class CreateSavedSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_searches do |t|
      t.string :name, null: false
      t.jsonb :criteria, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
