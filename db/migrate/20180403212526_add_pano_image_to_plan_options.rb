class AddPanoImageToPlanOptions < ActiveRecord::Migration[5.1]
  def change
    add_attachment :plan_options, :pano_image
  end
end
