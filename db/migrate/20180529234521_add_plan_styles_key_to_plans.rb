class AddPlanStylesKeyToPlans < ActiveRecord::Migration[5.1]
  def change
    add_reference :plans, :plan_style, foreign_key: true
  end
end
