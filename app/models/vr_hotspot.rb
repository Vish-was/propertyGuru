class VrHotspot < ApplicationRecord
  belongs_to :vr_scene
  belongs_to :plan_option_set, optional: true
  self.inheritance_column = nil
  validates_presence_of :name
end
