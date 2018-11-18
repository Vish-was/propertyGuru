require 'rails_helper'

RSpec.describe VrScene, type: :model do
  it { should belong_to(:plan) }
  it { should have_many(:vr_hotspots).dependent(:destroy) }
end
