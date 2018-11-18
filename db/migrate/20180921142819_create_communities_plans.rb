class CreateCommunitiesPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :communities_plans do |t|
      t.references :community, foreign_key: true
      t.references :plan, foreign_key: true
      t.integer   :base_price, null: false
      t.timestamps
    end
  end
end
