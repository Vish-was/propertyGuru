class CommunitiesPlan < ApplicationRecord
  belongs_to :community
  belongs_to :plan
end
