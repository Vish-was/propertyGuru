require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "PlanRooms" do
  header "Accept", "application/json"

  let!(:plan_rooms) { create_list(:plan_room, 10) }

  # Test suite for GET /plan_rooms
  describe 'GET /plan_rooms' do
    # make HTTP get request before each example
    before { get '/plan_rooms', as: :json }

    it 'returns plan_rooms' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end  