class ColumnChangesToVrHotspots < ActiveRecord::Migration[5.1]
  def change
  	remove_column :vr_hotspots, :is_toggle, :boolean
  	add_column :vr_hotspots, :type, :string, null:false, default:"menu"
  	add_column :vr_hotspots, :toggle_method, :string, null:true
  	add_reference :vr_hotspots, :show_on_plan_option, references: :plan_option, null: true, index: false
  	add_reference :vr_hotspots, :hide_on_plan_option, references: :plan_option, null: true, index: false
  end
end
