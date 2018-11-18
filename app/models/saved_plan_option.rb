class SavedPlanOption < ApplicationRecord
  belongs_to :saved_plan
  belongs_to :plan_option_set
  belongs_to :plan_option
  
  validates_presence_of :saved_plan_id, :plan_option_id

  scope :saved_plan_id, -> (saved_plan_id) { where "saved_plan_id = ? ", saved_plan_id}
  scope :plan_option_set_id, -> (plan_option_set_id) { where "plan_option_set_id = ?", plan_option_set_id }

  def self.filtering_params(params)
    params.slice(:saved_plan_id, :plan_option_set_id)
  end
end
