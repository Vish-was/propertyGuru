require 'rails_helper'

RSpec.describe SavedPlan, type: :model do
  it { should belong_to(:plan) }
  it { should belong_to(:user) }

  it { should have_many(:saved_plan_options) }

  it { should validate_presence_of(:plan_id) }
  it { should validate_presence_of(:user_id) }
end
