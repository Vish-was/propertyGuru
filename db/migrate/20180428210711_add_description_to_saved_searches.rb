class AddDescriptionToSavedSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :saved_searches, :description, :text
    add_column :saved_plans, :description, :text
  end
end
