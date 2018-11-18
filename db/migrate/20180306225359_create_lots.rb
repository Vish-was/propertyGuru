class CreateLots < ActiveRecord::Migration[5.1]
  def change
    create_table :lots do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.text :information
      t.decimal :price, null: false, default: 0
      t.integer :sqft
      t.references :division, foreign_key: true

      t.timestamps
    end
  end
end
