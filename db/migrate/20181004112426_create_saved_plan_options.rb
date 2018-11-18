class CreateSavedPlanOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_plan_options do |t|
      t.decimal :quoted_price, precision: 12, scale: 2, null: true
      t.references :saved_plan, foreign_key: true, null: false
      t.references :plan_option_set, foreign_key: true, null: false
      t.references :plan_option, foreign_key: true, null: false

      t.timestamps
    end
    add_index(:saved_plan_options, [:saved_plan_id, :plan_option_set_id], unique: true, name: 'saved_plan_and_plan_option_set')
  end
end
