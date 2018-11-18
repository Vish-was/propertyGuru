class CreateVrScenes < ActiveRecord::Migration[5.1]
  def change
    create_table :vr_scenes do |t|
      t.string :name, null: false
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
