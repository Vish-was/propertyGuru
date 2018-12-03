class Community < ApplicationRecord
  belongs_to :division

  has_many :lots, dependent: :destroy
  has_many :communities_plans, dependent: :destroy
  has_many :plans, through: :communities_plans
  has_many :community_plan_options, dependent: :destroy
  has_many :plan_options, :through => :community_plan_options

  has_and_belongs_to_many :amenities, :join_table => :communities_amenities
  has_many :community_gallery, dependent: :destroy

  accepts_nested_attributes_for :communities_plans

  validates_presence_of :name
  validates_presence_of :location

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  scope :starts_with, -> (starts_with) { where "lower(communities.name) like ?", "#{starts_with}%".downcase}
  
  def self.filtering_params(params)
    params.slice(:starts_with)
  end
end