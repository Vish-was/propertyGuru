require 'rails_helper'

RSpec.describe VrHotspot, type: :model do
	it { should belong_to(:vr_scene) }
	it { should belong_to(:plan_option_set) }
end
