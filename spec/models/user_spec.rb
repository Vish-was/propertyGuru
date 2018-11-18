require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
	
  it { should have_many(:saved_plans) }
  it { should have_many(:plans).through(:saved_plans) }
  it { should have_many(:user_viewed_plans) }
  it { should have_many(:viewed_plans).through(:user_viewed_plans).source(:plan) }
  it { should have_and_belong_to_many(:builders)}

  # Validation tests
  # it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:profile) }
end
