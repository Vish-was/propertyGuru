require 'rails_helper'

RSpec.describe Region, type: :model do

  # Association test
  # ensure a region record belongs to a single builder record
  it { should belong_to(:builder) }

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }

end
