class AddAttachmentThumbnailImageToPlanOptions < ActiveRecord::Migration[5.1]
  def self.up
    change_table :plan_options do |t|
      t.attachment :thumbnail_image
    end
  end

  def self.down
    remove_attachment :plan_options, :thumbnail_image
  end
end
