require 'rails_helper'

RSpec.describe Amenity, type: :model do
  # Association test
  it { should have_and_belong_to_many(:communities).join_table('communities_amenities') }

  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }

  # let!(:scope) { :scope, :starts_with, where "lower(amenities.name) like ?", "#{starts_with}%".downcase }

  # expect(Amenity.scope).to match_array(expected_collection)
end
