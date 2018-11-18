require 'rails_helper'

RSpec.describe SavedPlanOption, type: :model do
  it { should belong_to(:saved_plan) }
  it { should belong_to(:plan_option_set) }
  it { should belong_to(:plan_option) }
end
