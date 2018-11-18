class AddNewColumnsToPlanOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :plan_options, :vr_parameter, :text, null: true
    add_column :plan_options, :type, :string, null: false, default: 'uncategorized'
    add_column :plan_options, :sqft_living, :integer, null: true
    add_column :plan_options, :sqft_porch, :integer, null: true
    add_column :plan_options, :sqft_patio, :integer, null: true
    add_column :plan_options, :width, :integer, null: true
    add_column :plan_options, :depth, :integer, null: true
  end
end
