class CreateCommunityGallery < ActiveRecord::Migration[5.1]
  def change
    create_table :community_gallery do |t|
      t.references :community, foreign_key: true
      t.attachment :image, null: false
    end
  end
end
