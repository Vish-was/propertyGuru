require 'rails_helper'

RSpec.describe PlanOptionSet, type: :model do
  it { should belong_to(:plan) }
  it { should have_many(:saved_plan_options) }
  it { should have_one(:vr_hotspot) }
  it { should have_many(:plan_options).dependent(:destroy) }
  it { should validate_presence_of(:story) }
end
