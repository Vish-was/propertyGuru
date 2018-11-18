require 'rails_helper'

RSpec.describe ExcludedPlanOption, type: :model do

  it { should belong_to(:plan_option) }

end
