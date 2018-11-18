class VrScene < ApplicationRecord
  belongs_to :plan
  has_many :vr_hotspots, dependent: :destroy

  validates_presence_of :name
  
  def initial_scene_image
    vr_hotspots = self.vr_hotspots.order(:id)
    scene_image = ""
    vr_hotspots.each do |vr_hotspot|
      scene_image = scene_image + "#{vr_hotspot.plan_option_set.id}x#{vr_hotspot.plan_option_set.default_plan_option_id}_" if vr_hotspot.plan_option_set.present?
    end	
    scene_image = scene_image.chomp("_")
    return "https://mhb-production.s3.amazonaws.com/paperclip/vr_scenes/#{self.id}/#{scene_image}.jpg" if vr_hotspots.present?
  end	
end
