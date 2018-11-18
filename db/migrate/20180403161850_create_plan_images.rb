class CreatePlanImages < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_images do |t|
      t.references :plan, foreign_key: true
      t.decimal :story, null: false
      t.attachment :base_image, null: false
    end

    remove_attachment :plans, :base_image
    add_column :plan_options, :story, :decimal, default: 1.0, null: false
  end
end
