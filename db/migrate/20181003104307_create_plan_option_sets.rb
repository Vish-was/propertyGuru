class CreatePlanOptionSets < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_option_sets do |t|
      t.string :name, null: false
      t.references :default_plan_option, references: :plan_options, null: true
      t.references :plan, foreign_key: true, null: false
      t.string :position_2d, null: true
      t.string :string

      t.timestamps
    end
  end
end
