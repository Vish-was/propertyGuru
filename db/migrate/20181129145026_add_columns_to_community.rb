class AddColumnsToCommunity < ActiveRecord::Migration[5.1]
  def change
    add_attachment :communities, :image, null: true
    add_column :communities, :information, :text, null: true
  end
end
