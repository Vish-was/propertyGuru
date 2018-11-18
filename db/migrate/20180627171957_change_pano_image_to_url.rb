class ChangePanoImageToUrl < ActiveRecord::Migration[5.1]
  def change
    remove_attachment :plan_options, :pano_image
    add_column :plan_options, :pano_image, :text
  end
end
