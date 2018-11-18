class CreateSavedPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_plans do |t|
      t.references :plan, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :elevation, foreign_key: true
      t.references :contact, foreign_key: true
      t.integer :plan_option_ids, array: true, default: []
      t.decimal :quoted_price, :precision => 12, :scale => 2

      t.datetime :ordered_at
      t.datetime :completed_at
      t.timestamps
    end
  end
end
