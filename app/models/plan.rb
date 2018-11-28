class Plan < ApplicationRecord
  belongs_to :collection

  has_many :plan_images, dependent: :destroy
  has_many :elevations, dependent: :destroy
  has_many :saved_plans, dependent: :destroy
  has_many :users, through: :saved_plans
  has_many :vr_scenes, dependent: :destroy
  has_many :plan_option_sets, dependent: :destroy
  has_many :communities_plans, dependent: :destroy
  has_many :communities, through: :communities_plans
  has_many :plan_options, through: :plan_option_sets
  has_many :user_viewed_plans, dependent: :destroy
  has_many :viewers, through: :user_viewed_plans, source: :user

  has_and_belongs_to_many :plan_styles, :join_table => :plans_plan_styles
  has_and_belongs_to_many :lots, :join_table => :plans_lots

  accepts_nested_attributes_for :communities_plans

  validates_presence_of :name, :min_price, :min_sqft, :min_bedrooms, 
                        :min_bathrooms, :min_garage, :min_stories, :image

  has_attached_file :image
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/


  scope :minimum_price, -> (minimum_price) { where "min_price >= ?", minimum_price }
  scope :maximum_price, -> (maximum_price) { where "min_price <= ?", maximum_price }
  scope :minimum_size, -> (minimum_size) { where "min_sqft >= ?", minimum_size }
  scope :maximum_size, -> (maximum_size) { where "min_sqft <= ?", maximum_size }
  scope :minimum_bedrooms, -> (minimum_bedrooms) { where "min_bedrooms >= ?", minimum_bedrooms }
  scope :minimum_bathrooms, -> (minimum_bathrooms) { where "min_bathrooms >= ?", minimum_bathrooms }
  scope :minimum_garages, -> (minimum_garages) { where "min_garage >= ?", minimum_garages }
  scope :minimum_stories, -> (minimum_stories) { where "min_stories >= ?", minimum_stories }
  scope :starts_with, -> (starts_with) { where "lower(plans.name) like ?", "#{starts_with}%".downcase}
  scope :popular_top, -> (popular_top_count) { joins(:user_viewed_plans).select("count(*) as plan_view_count, plans.*").group('plans.id').order("plan_view_count desc").limit(popular_top_count) }
  scope :builder_id, -> (builder_id) {includes(:collection => {:region => :builder}).where(builders: {id: builder_id}) }
  scope :has_reduced_price, -> () { }
  scope :location, -> (location_id) {  }
  scope :within_miles, -> (miles) {  }
  scope :plan_style_ids, -> (plan_style_ids) { joins(:plans_plan_styles).where(["plan_style_id IN (?)", plan_style_ids.split(',').map(&:to_i)])}


  def self.filtering_params(params)
    params.slice(:location, :within_miles, :minimum_price, :maximum_price,
      :minimum_size, :maximum_size, :minimum_bedrooms,
      :minimum_bathrooms, :minimum_garages, :minimum_stories,
      :starts_with, :popular_top, :has_reduced_price, :builder_id, :plan_style_ids)
  end

end
