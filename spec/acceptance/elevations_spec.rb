require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Elevations" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:elevations) { create_list(:elevation, 20, plan_id: plan.id) }

  let!(:elevation_to_test) { elevations.sample }
  let(:plan_id) { plan.id }
  let(:id) { elevation_to_test.id }

  let(:page_size) { Faker::Number.between(1, elevations.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/plans/:plan_id/elevations" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all elevations for a plan" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all elevations, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Elevation)
      expect(response_size).to eq(paged_size(elevations, page_size))
      expect(json['total_count']).to eq(elevations.size)

      expect(status).to eq(200)
    end

    example_request "Get all elevations, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Elevation)
      expect(response_size).to eq(paged_size(elevations, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all elevations, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Elevation)
      expect(response_size).to eq(paged_size(elevations, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/elevations/:id" do
    example_request "Get a specific elevation" do
      expect(status).to eq(200)
    end
  end

end