class ChangeColumnToNull < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :plans, :max_price, true
  	change_column_null :plans, :max_sqft, true
  	change_column_null :plans, :max_bedrooms, true
  	change_column_null :plans, :max_bathrooms, true
  	change_column_null :plans, :max_garage, true
  	change_column_null :plans, :max_stories, true
  end
end
