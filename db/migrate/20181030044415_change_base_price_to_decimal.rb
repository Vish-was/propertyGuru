class ChangeBasePriceToDecimal < ActiveRecord::Migration[5.1]
  def self.up
    change_column :communities_plans, :base_price, :decimal
    change_column :community_plan_options, :base_price, :decimal
  end

  def self.down
    change_column :communities_plans, :base_price, :integer
    change_column :community_plan_options, :base_price, :integer
  end	
end
