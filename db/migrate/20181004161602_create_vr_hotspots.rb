class CreateVrHotspots < ActiveRecord::Migration[5.1]
  def change
    create_table :vr_hotspots do |t|
      t.string :name, null: false
      t.references :vr_scene, foreign_key: true
      t.references :plan_option_set, foreign_key: true, null: true
      t.references :jump_scene, references: :vr_scene, null: true
      t.string :position, null: true
      t.string :rotation, null: true
      t.boolean :toggle, null: false

      t.timestamps
    end
  end
end
