class RemovePlanIdFromPlanOptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :plan_options, :plan_id, :integer
    add_column :plan_options, :plan_option_set_id, :integer
  end
end
