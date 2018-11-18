class PlanOption < ApplicationRecord
  belongs_to :plan_option_set
  
  has_many :excluded_plan_options, dependent: :destroy
  has_many :community_plan_options, dependent: :destroy
  has_many :saved_plan_options, dependent: :destroy
  has_many :communities, :through => :community_plan_options

  self.inheritance_column = nil
  # validates_presence_of :name, :default_price, :category, 
                        # :thumbnail_image, :plan_image, :type

  has_attached_file :thumbnail_image
  validates_attachment_content_type :thumbnail_image, content_type: /\Aimage\/.*\z/

  has_attached_file :plan_image
  validates_attachment_content_type :plan_image, content_type: /\Aimage\/.*\z/

  def price_total
    return self.default_price
  end 

  def price_monthly
    return self.default_price*0.0041
  end 

end
