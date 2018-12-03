class CommunityGallery < ApplicationRecord
  self.table_name = "community_gallery"
  belongs_to :community

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_presence_of :image
end