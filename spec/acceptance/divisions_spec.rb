require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Divisions" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:divisions) { create_list(:division, 25, region_id: region.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plans) { create_list(:plan, 25, collection_id: collection.id) }

  let!(:division_to_test) { divisions.sample }
  let!(:region_id) { region.id }
  let!(:id) { division_to_test.id }
  let!(:user) { create(:user) }

  let(:page_size) { Faker::Number.between(1, divisions.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/regions/:region_id/divisions" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all divisions" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all divisions, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Division)
      expect(response_size).to eq(paged_size(divisions, page_size))
      expect(json['total_count']).to eq(divisions.size)
      expect(status).to eq(200)
    end

    example_request "Get all divisions, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Division)
      expect(response_size).to eq(paged_size(divisions, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all divisions, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Division)
      expect(response_size).to eq(paged_size(divisions, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/divisions/:id" do
    example_request "Get a specific division" do
      expect(status).to eq(200)
    end
  end

  post "/regions/:region_id/divisions" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for the Division", required: true
  
    example_request "Create a new Division" do
      name = Faker::Name.name 

      do_request( name: name )
      expect(json['name']).to eq(name)
      expect(status).to eq(201)
    end
  end

  put "/divisions/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for the Division", required: true

    example_request "Rename a Division" do
      name = Faker::Name.name 
      do_request(name: name)

      division = Division.find(id)
      expect(division.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/divisions/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a Division" do
      division_id = create(:division, name: "Delete me", region_id: region_id).id

      do_request(id: division_id)

      expect(Division.where(id: division_id).size).to be(0)
      expect(status).to eq(204)
    end
  end
  
  get "/divisions/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    example_request "Get all plans" do
      do_request
      expect(status).to eq(200)
    end

    example "Get all plans from division, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from division, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from division, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end
end