class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.string :name, null: false
      t.text :information
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
