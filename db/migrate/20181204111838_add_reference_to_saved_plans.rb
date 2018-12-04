class AddReferenceToSavedPlans < ActiveRecord::Migration[5.1]
  def change
  	add_reference :saved_plans, :community, null: true, foreign_key: true
  end
end
