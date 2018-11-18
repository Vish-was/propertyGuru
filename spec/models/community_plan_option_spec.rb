require 'rails_helper'

RSpec.describe CommunityPlanOption, type: :model do
  it { should belong_to(:plan_option) }
  it { should belong_to(:community) }
end
