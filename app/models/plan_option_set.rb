class PlanOptionSet < ApplicationRecord
  belongs_to :plan
  has_many :plan_options, dependent: :destroy
  has_many :saved_plan_options, dependent: :destroy
  has_one :vr_hotspot

  validates_presence_of :name, :story

  scope :position_2d, -> (position_2d) { where "position_2d = ?", position_2d }
  scope :story, -> (story) { where story: story }
end
