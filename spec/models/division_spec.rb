require 'rails_helper'

RSpec.describe Division, type: :model do

  # Association test
  # ensure a division record belongs to a single region record
  it { should belong_to(:region) }
  it { should have_many(:communities).dependent(:destroy) }

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }

end
