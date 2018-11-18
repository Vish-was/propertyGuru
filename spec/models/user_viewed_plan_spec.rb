require 'rails_helper'

RSpec.describe UserViewedPlan, type: :model do
  it { should belong_to(:plan) }
  it { should belong_to(:user) }
end
