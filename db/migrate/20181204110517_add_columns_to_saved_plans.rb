class AddColumnsToSavedPlans < ActiveRecord::Migration[5.1]
  def change
  	add_column :saved_plans, :is_favorite, :boolean, null: false, default: false
    add_column :saved_plans, :is_public, :boolean, null: false, default: false
  end
end
