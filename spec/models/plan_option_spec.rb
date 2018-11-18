require 'rails_helper'

RSpec.describe PlanOption, type: :model do
  it { should belong_to(:plan_option_set) }
  it { should have_many(:community_plan_options) }
  it { should have_many(:communities).through(:community_plan_options) }
  it { should have_many(:saved_plan_options) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:default_price) }
  it { should validate_presence_of(:category) }
  it { should_not validate_presence_of(:information) }
  it { should_not validate_presence_of(:sqft_ac) }
  it { should validate_presence_of(:thumbnail_image) }
  it { should validate_presence_of(:plan_image) }
  it { should validate_presence_of(:type) }
  it { should_not validate_presence_of(:vr_parameter) } 
  it { should_not validate_presence_of(:sqft_living) }
  it { should_not validate_presence_of(:sqft_porch) }
  it { should_not validate_presence_of(:sqft_patio) }
  it { should_not validate_presence_of(:width) }
  it { should_not validate_presence_of(:depth) }
end
