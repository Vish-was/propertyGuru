require 'rails_helper'
require "cancan/matchers"

# Test suite for Ability model
RSpec.describe Ability, type: :model do
  context 'When user is Admin' do
    let!(:user) { create(:user) }
    before { user.add_role(:admin)
     }
    it "Admin is manage all ability" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:manage, :all)
    end
  end
  context 'When user is Builder' do
    let!(:user) { create(:user) }
    before { user.add_role(:builder)
     }
    it "Builder is manage all ability" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:manage, :all)
    end
  end
  context 'When user is not admin or builder' do
    let!(:user) { create(:user) }
    it "User is read all ability" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, :all)
    end
  end
end
