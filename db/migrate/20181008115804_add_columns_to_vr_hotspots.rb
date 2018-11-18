class AddColumnsToVrHotspots < ActiveRecord::Migration[5.1]
  def change
  	add_column :vr_hotspots, :toggle_default, :boolean, null: false
  end
end
