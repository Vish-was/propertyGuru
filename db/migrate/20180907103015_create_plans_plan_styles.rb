class CreatePlansPlanStyles < ActiveRecord::Migration[5.1]
  def change
    create_table :plans_plan_styles do |t|
      t.belongs_to  :plan, index: true
      t.belongs_to  :plan_style, index: true
    end
  end
end
