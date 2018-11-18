class AddColumnsToVrScenes < ActiveRecord::Migration[5.1]
  def change
  	add_column :vr_scenes, :initial_scene_image, :string, null: false
  end
end
