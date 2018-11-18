class AddColumnsToPlan < ActiveRecord::Migration[5.1]
  def change
  	add_column :plans, :max_price, :decimal, precision: 12, scale: 2
  	add_column :plans, :max_sqft, :integer, null: true
  	add_column :plans, :max_bedrooms, :decimal, null: true
  	add_column :plans, :max_bathrooms, :decimal, null: true
  	add_column :plans, :max_garage, :decimal, null: true
  end
end
