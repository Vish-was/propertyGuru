class RemoveInitialSceneImageFromVrScenes < ActiveRecord::Migration[5.1]
  def change
  	remove_column :vr_scenes, :initial_scene_image, :string
  end
end
