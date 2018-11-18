class AddHouseAttrToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :base_sqft, :integer, null: false
    add_column :plans, :base_bedrooms, :decimal, null: false
    add_column :plans, :base_bathrooms, :decimal, null: false
    add_column :plans, :base_garage, :decimal, null: false

  end
end
