class CreatePlanStyles < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_styles do |t|
      t.string :name

      t.timestamps
    end
  end
end
