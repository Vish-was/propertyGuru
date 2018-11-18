require 'rails_helper'

RSpec.describe PlanStyle, type: :model do
  it { should have_and_belong_to_many(:plans) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:image) }

end
