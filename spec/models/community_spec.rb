require 'rails_helper'

RSpec.describe Community, type: :model do


  # Association test
  it { should belong_to(:division) }
  it { should have_many(:lots) }
  it { should have_many(:community_plan_options) }
  it { should have_many(:plan_options).through(:community_plan_options) }
  it { should have_and_belong_to_many(:amenities) }
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:location) }
end
