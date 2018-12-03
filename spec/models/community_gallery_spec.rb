require 'rails_helper'

RSpec.describe CommunityGallery, type: :model do
  it { should belong_to(:community) }
  it { should validate_presence_of(:image) }
end