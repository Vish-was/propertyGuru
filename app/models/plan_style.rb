class PlanStyle < ApplicationRecord
  has_and_belongs_to_many :plans, :join_table => :plans_plan_styles

  validates_presence_of :name, :image

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/


  scope :starts_with, -> (starts_with) { where "lower(plan_styles.name) like ?", "#{starts_with}%".downcase}

  def self.filtering_params(params)
    params.slice(:starts_with)
  end
end
