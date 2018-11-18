class PlanImage < ApplicationRecord
  belongs_to :plan

  validates_presence_of :story, :base_image

  has_attached_file :base_image
  validates_attachment_content_type :base_image, content_type: /\Aimage\/.*\z/

  scope :story, -> (story) { where story: story }

end
