class AddAttachmentImageToPlanStyles < ActiveRecord::Migration[5.1]
  def self.up
    change_table :plan_styles do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :plan_styles, :image
  end
end
