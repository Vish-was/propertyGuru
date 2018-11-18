class CreateCommunitiesAmenities < ActiveRecord::Migration[5.1]
  def change
    create_table :communities_amenities do |t|
      t.belongs_to  :community, index: true
      t.belongs_to  :amenity, index: true
    end
  end
end
