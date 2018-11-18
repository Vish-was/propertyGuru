class AddColumnToLot < ActiveRecord::Migration[5.1]
  def change
  	add_column :lots, :name, :string, null: false
  	add_column :lots, :location, :text, null: false
  	add_column :lots, :length, :integer, null: true
  	add_column :lots, :width, :integer, null: true
  	add_column :lots, :setback_front, :integer, null: true
  	add_column :lots, :setback_back, :integer, null: true
  	add_column :lots, :setback_left, :integer, null: true
  	add_column :lots, :setback_right, :integer, null: true
  	change_column_null :lots, :information, true
  end
end
