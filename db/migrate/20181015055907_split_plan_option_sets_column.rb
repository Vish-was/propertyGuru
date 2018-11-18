class SplitPlanOptionSetsColumn < ActiveRecord::Migration[5.1]
  def change
  	remove_column :plan_option_sets, :position_2d, :string
  	add_column :plan_option_sets, :position_2d_x, :float, null: true
  	add_column :plan_option_sets, :position_2d_y, :float, null: true
  end
end
