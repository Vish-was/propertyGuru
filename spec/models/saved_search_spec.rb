require 'rails_helper'

RSpec.describe SavedSearch, type: :model do
  it { should belong_to(:user) }


  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:criteria) }
end
