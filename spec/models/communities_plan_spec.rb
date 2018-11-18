require 'rails_helper'

RSpec.describe CommunitiesPlan, type: :model do
  it { should belong_to(:community) }
  it { should belong_to(:plan) }
end
