class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.text :information
      t.decimal :base_price, :precision => 12, :scale => 2
      t.references :collection, foreign_key: true

      t.timestamps
    end
  end
end
