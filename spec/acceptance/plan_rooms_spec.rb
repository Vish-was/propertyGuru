require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "PlanRooms" do
  header "Accept", "application/json"
  let!(:plan_rooms) { create_list(:plan_room, 25) }

  let(:page_size) { Faker::Number.between(1, plan_rooms.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/plan_rooms" do
    
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all plan_rooms" do
      expect(status).to eq(200)
    end

    example "Get all plan_rooms, limited by page size" do
      do_request(per_page: page_size)

      expect(status).to eq(200)
    end

    example_request "Get all plan_rooms, with paging" do
      do_request(per_page: page_size, page: 2)

      expect(status).to eq(200)
    end

    example_request "Get all plan_rooms, with random page" do
      do_request(per_page: page_size, page: page_number)

      expect(status).to eq(200)
    end
  end
end  