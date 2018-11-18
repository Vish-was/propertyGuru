require 'rails_helper'

RSpec.describe Lot, type: :model do

  # Association test
  # ensure a division record belongs to a single region record
  it { should belong_to(:community) }
  it { should have_and_belong_to_many(:plans)}


  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:price) }
  it { should_not validate_presence_of(:information) }
  it { should_not validate_presence_of(:sqft) }

end
