class CreateCommunityPlanOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :community_plan_options do |t|
      t.references :community, index: true, foreign_key: true
      t.references :plan_option, index: true, foreign_key: true
      t.integer   :base_price, null: false
      t.timestamps
    end
  end
end
