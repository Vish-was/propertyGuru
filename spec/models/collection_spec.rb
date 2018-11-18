require 'rails_helper'

RSpec.describe Collection, type: :model do

  # Association test
  # ensure a collection record belongs to a single region record
  it { should belong_to(:region) }
  it { should have_many(:plans).dependent(:destroy) }

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
  it { should_not validate_presence_of(:information) }

end
