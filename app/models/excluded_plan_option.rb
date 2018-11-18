class ExcludedPlanOption < ApplicationRecord
  belongs_to :plan_option
  has_many :plan_options, dependent: :destroy, :foreign_key => 'excluded_plan_option_id' 

end
