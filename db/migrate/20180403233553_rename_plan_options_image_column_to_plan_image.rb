class RenamePlanOptionsImageColumnToPlanImage < ActiveRecord::Migration[5.1]
  def change
    rename_column :plan_options, :image_file_name, :plan_image_file_name
    rename_column :plan_options, :image_file_size, :plan_image_file_size
    rename_column :plan_options, :image_content_type, :plan_image_content_type
    rename_column :plan_options, :image_updated_at, :plan_image_updated_at 
  end
end
