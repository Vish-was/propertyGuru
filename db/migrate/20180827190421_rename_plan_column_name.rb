class RenamePlanColumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :plans, :base_price, :min_price
  	rename_column :plans, :base_sqft, :min_sqft
  	rename_column :plans, :base_bedrooms, :min_bedrooms
  	rename_column :plans, :base_bathrooms, :min_bathrooms
  	rename_column :plans, :base_garage, :min_garage
  end
end
