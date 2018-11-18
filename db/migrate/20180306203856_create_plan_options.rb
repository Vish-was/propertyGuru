class CreatePlanOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_options do |t|
      t.string :name, null: false
      t.text :information
      t.decimal :price, null: false
      t.text :category, null: false
      t.integer :sqft
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
