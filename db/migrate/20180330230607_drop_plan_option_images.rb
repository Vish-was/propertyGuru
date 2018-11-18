class DropPlanOptionImages < ActiveRecord::Migration[5.1]
  def change
    drop_table :plan_option_images
  end
end
