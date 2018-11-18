class AddImageColumns < ActiveRecord::Migration[5.1]
  def up
    add_attachment :elevations, :image
    add_attachment :plans, :base_image
    add_attachment :plan_options, :image
  end

  def down
    remove_attachment :elevation, :image
    remove_attachment :plans, :base_image
    remove_attachment :plan_options, :image
  end
end
