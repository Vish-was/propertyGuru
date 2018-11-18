class CreateUserViewedPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :user_viewed_plans do |t|
      t.references :user, index: true, foreign_key: true
      t.references :plan, index: true, foreign_key: true

      t.timestamps
    end
  end
end
