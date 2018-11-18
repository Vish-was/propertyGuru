require 'rails_helper'

RSpec.describe Plan, type: :model do
  # Association test
  it { should belong_to(:collection) }
  it { should have_and_belong_to_many(:plan_styles) }
  it { should have_many(:saved_plans).dependent(:destroy) }
  it { should have_many(:users).through(:saved_plans) }
  it { should have_many(:elevations).dependent(:destroy) }
  it { should have_many(:plan_option_sets).dependent(:destroy) }
  it { should have_many(:plan_images).dependent(:destroy) }
  it { should have_many(:vr_scenes).dependent(:destroy) }

  it { should have_many(:user_viewed_plans) }
  it { should have_many(:viewers).through(:user_viewed_plans).source(:user) }
  it { should have_and_belong_to_many(:lots)}

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:min_price) }
  it { should validate_presence_of(:image) }
  it { should_not validate_presence_of(:information) }

end
