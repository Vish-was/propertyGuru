class AddColumnToBuilder < ActiveRecord::Migration[5.1]
  def change
  	add_column :builders, :production, :boolean, null: true
  	add_column :builders, :website, :text, null: true
  	add_attachment :builders, :logo, null: true
  	add_column :builders, :about, :text, null: true
  	add_column :builders, :locations, :text, null: true
  end
end
