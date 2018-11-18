require 'rails_helper'

RSpec.describe Elevation, type: :model do
  # Association test
  # ensure a division record belongs to a single region record
  it { should belong_to(:plan) }

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should_not validate_presence_of(:description) }

end
