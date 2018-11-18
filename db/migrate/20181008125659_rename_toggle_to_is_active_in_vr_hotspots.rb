class RenameToggleToIsActiveInVrHotspots < ActiveRecord::Migration[5.1]
  def change
  	rename_column :vr_hotspots, :toggle, :is_active
  end
end
