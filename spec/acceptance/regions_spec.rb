require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Regions" do
  header "Accept", "application/json"
  

  let!(:builder) { create(:builder) }
  let!(:regions) { create_list(:region, 25, builder_id: builder.id) }

  let!(:region_to_test) { regions.sample }
  let!(:builder_id) { builder.id }
  let!(:id) { region_to_test.id }
  let!(:user) { create(:user) }

  let(:page_size) { Faker::Number.between(1, regions.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/builders/:builder_id/regions" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "List all regions" do
      do_request

      result_compare_with_db(json, Region)
      expect(status).to eq(200)
    end

    example "Get all regions, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Region)
      expect(response_size).to eq(paged_size(regions, page_size))
      expect(json['total_count']).to eq(regions.size)
      expect(status).to eq(200)
    end

    example_request "Get all regions, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Region)
      expect(response_size).to eq(paged_size(regions, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all regions, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Region)
      expect(response_size).to eq(paged_size(regions, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/regions/:id" do
    example_request "Get a specific region" do
      expect(status).to eq(200)
    end
  end

  post "/builders/:builder_id/regions" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name of the Region", required: true
  
    example_request "Create a new Region" do
      name = Faker::Name.name 

      do_request( name: name )
      expect(json['name']).to eq(name)
      expect(status).to eq(201)
    end
  end

  put "/regions/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name of the Region", required: true

    example_request "Rename a Rename" do
      name = Faker::Name.name 
      do_request(name: name)

      region = Region.find(id)
      expect(region.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/regions/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a Region" do
      region_id = create(:region, name: "Delete me", builder_id: builder_id).id

      do_request(id: region_id)

      expect(Region.where(id: region_id).size).to be(0)
      expect(status).to eq(204)
    end
  end
end