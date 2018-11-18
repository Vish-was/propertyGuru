class CreatePlanOptionImages < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_option_images do |t|
      t.string :name
      t.bigint :plan_option_hash
      t.integer :plan_option_id, array: true, null: false
      t.attachment :image
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
