class PlanRoom < ApplicationRecord
  validates_presence_of :name, :type

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/	
  self.inheritance_column = nil
end
