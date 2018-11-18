class CreateElevations < ActiveRecord::Migration[5.1]
  def change
    create_table :elevations do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, null: false, default: 0
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
