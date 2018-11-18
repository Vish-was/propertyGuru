class CommunityPlanOption < ApplicationRecord
  belongs_to :community
  belongs_to :plan_option
end
