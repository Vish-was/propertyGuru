class AddNameToSavedPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :saved_plans, :name, :string
  end
end
