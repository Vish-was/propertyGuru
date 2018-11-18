class RenamePlanOptionColumns < ActiveRecord::Migration[5.1]
  def change 
    rename_column :plan_options, :price, :default_price
    rename_column :plan_options, :sqft, :sqft_ac
  end
end
