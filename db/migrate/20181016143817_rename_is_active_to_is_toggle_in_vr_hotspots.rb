class RenameIsActiveToIsToggleInVrHotspots < ActiveRecord::Migration[5.1]
  def change
  	rename_column :vr_hotspots, :is_active, :is_toggle
  end
end
