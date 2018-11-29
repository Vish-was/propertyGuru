class AddAttachmentImageToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_attachment :users, :image, null: true
  end
end
