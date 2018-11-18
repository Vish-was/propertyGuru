class RemovePlanStyleIdFromPlans < ActiveRecord::Migration[5.1]
  def change
    remove_column :plans, :plan_style_id, :integer
  end
end
