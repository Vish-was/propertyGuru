class RemoveColumnsFromPlanOptionSets < ActiveRecord::Migration[5.1]
  def change
  	remove_column :plan_option_sets, :string, :string
  end
end
