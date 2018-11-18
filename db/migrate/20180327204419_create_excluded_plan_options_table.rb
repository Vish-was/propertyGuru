class CreateExcludedPlanOptionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :excluded_plan_options do |t|
      t.integer :plan_option_id
      t.integer :excluded_plan_option_id

      t.timestamps
    end

    add_index :excluded_plan_options, :plan_option_id
    add_foreign_key :excluded_plan_options, :plan_options, column: :plan_option_id
    add_foreign_key :excluded_plan_options, :plan_options, column: :excluded_plan_option_id
  end
end
