class AddDefaultVrSceneIdToPlan < ActiveRecord::Migration[5.1]
  def change
  	add_reference :plans, :default_vr_scene, references: :vr_scene, null: true, index: false
  end
end
