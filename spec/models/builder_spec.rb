require 'rails_helper'

RSpec.describe Builder, type: :model do

  # Association test
  # ensure Builder model has a 1:m relationship with the Region model
  it { should have_many(:regions).dependent(:destroy) }
  it { should have_many(:contacts).dependent(:destroy) }
  it { should have_and_belong_to_many(:users)}

  # Validation tests
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }

 
end
