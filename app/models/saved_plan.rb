class SavedPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  belongs_to :elevation, optional: true
  belongs_to :contact, optional: true

  has_many :saved_plan_options
  
  validates_presence_of :plan_id, :user_id

  # Removed plan_option_ids might be need to check some other conditions
  scope :customized,     -> (ignored) { eager_load(:saved_plan_options).where("saved_plan_options.id IS NOT NULL") }
  scope :not_customized, -> (ignored) { eager_load(:saved_plan_options).where("saved_plan_options.id IS NULL") }

  def self.filtering_params(params)
    params.slice(:customized, :not_customized)
  end

  def vr_scene_images
    vr_scene_images = []
    self.plan.vr_scenes.each do |scene|
      hotspots = scene.vr_hotspots.where("plan_option_set_id is not null").order(:plan_option_set_id)
      scene_image = ""
      hotspots.each do |hotspot|
        user_selected_option = self.saved_plan_options.where(plan_option_set: hotspot.plan_option_set)&.pluck(:plan_option_id).first
        user_selected_option = hotspot.plan_option_set.default_plan_option_id if user_selected_option.blank?
        scene_image = scene_image + "#{hotspot.plan_option_set.id}x#{user_selected_option}_"
      end
      scene_image = scene_image.chomp("_")
      vr_scene_images.push({vr_scene_id: scene.id, vr_scene_image: "https://mhb-production.s3.amazonaws.com/paperclip/vr_scenes/#{scene.id}/#{scene_image}.jpg"})
    end
    vr_scene_images
  end
end
