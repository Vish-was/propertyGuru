class RemoveColumnFromSavedPlans < ActiveRecord::Migration[5.1]
  def change
  	remove_column :saved_plans, :plan_option_ids, :integer
  end
end
