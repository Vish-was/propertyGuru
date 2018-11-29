require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Communities" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:communities) { create_list(:community, 25, division_id: division.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:community_to_test) { communities.sample }
  let!(:division_id) { division.id }
  let!(:id) { community_to_test.id }
  let!(:user) { create(:user) }
  let!(:plan) { create(:plan,  collection_id: collection.id)}
  let!(:amenity) { create(:amenity)}
  let(:value) { Faker::Name.name }

  let(:page_size) { Faker::Number.between(1, communities.size) }
  let(:page_number) { Faker::Number.between(1, 10) }
  
  get "/divisions/:division_id/communities" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all communities with starts" do
      do_request
      expect(status).to eq(200)
    end

    example "Get all communities, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Community)
      expect(response_size).to eq(paged_size(communities, page_size))
      expect(json['total_count']).to eq(communities.size)
      expect(status).to eq(200)
    end

    example_request "Get all communities, with paging" do
      do_request(per_page: page_size, page: 2)
      expect(response_size).to eq(paged_size(communities, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all communities, with random page" do
      do_request(per_page: page_size, page: page_number)
      expect(response_size).to eq(paged_size(communities, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/communities/:id" do
    example_request "Get a specific lot" do
      expect(status).to eq(200)
    end
  end

  post "/divisions/:division_id/communities" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name of community", required: true
    parameter :location, "location of community"
    parameter :yearly_hoa_fees
    parameter :property_tax_rate
    parameter :image
    parameter :information

    example_request "Create a new Community" do
      name = Faker::Name.name 
      location = Faker::TwinPeaks.location
    
      do_request( name: name, location: location)

      expect(json['name']).to eq(name)
      expect(json['location']).to eq(location)
      expect(status).to eq(201)
    end
  end

  put "/communities/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name of community", required: true
    parameter :location, "location of community"
    parameter :yearly_hoa_fees
    parameter :property_tax_rate
    parameter :image
    parameter :information

    example_request "Rename a Community" do
      name = Faker::Name.name 
      location = Faker::TwinPeaks.location
      do_request(name: name)

      community = Community.find(id)
      expect(community.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/communities/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a community" do
      community_id = create(:community, name: "Delete Me!", division_id: division_id).id

      do_request(id: community_id)

      expect(Community.where(id: community_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

  get "/communities/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all plans from community" do
      do_request
      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example "Get all plans from community, limited by page size" do
      do_request(per_page: page_size)
      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from community, with paging" do
      do_request(per_page: page_size, page: 2)
      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from community, with random page" do
      do_request(per_page: page_size, page: page_number)
      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end

  post "/communities/:id/plans/:plan_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Community"
    parameter :plan_id, "id of the Plan"
    parameter :base_price, "base price of communities_plans"
    

    example_request "Create a new plan from community" do
      base_price = Faker::Number.decimal(5, 2)

      do_request(id: id, plan_id: plan.id, base_price: base_price)

      expect(status).to eq(200)
    end
  end

  put "/communities/:id/plans/:plan_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Community"
    parameter :plan_id, "id of the Plan"
    parameter :base_price, "base price of communities_plans"

    example_request "Update base_price" do
      base_price = Faker::Number.decimal(5, 2)
      do_request(id: id, plan_id: plan.id, base_price: base_price)

      expect(status).to eq(200)
    end
  end

  delete "/communities/:id/plans/:plan_id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan from community" do

      do_request(id: id, plan_id: plan.id)

      expect(status).to eq(200)
    end
  end

  get "/communities/:id/amenities" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all amenities from community" do
      do_request
      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end

    example "Get all amenities from community, limited by page size" do
      do_request(per_page: page_size)
      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end

    example_request "Get all amenities from community, with paging" do
      do_request(per_page: page_size, page: 2)
      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end

    example_request "Get all amenities from community, with random page" do
      do_request(per_page: page_size, page: page_number)
      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end
  end

  post "/communities/:id/amenities/:amenity_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Community"
    parameter :amenity_id, "id of the Amenity"
    

    example_request "Create a new amenity from community" do


      do_request(id: id, amenity_id: amenity.id)

      expect(status).to eq(200)
    end
  end

  delete "/communities/:id/amenities/:amenity_id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan from community" do

      do_request(id: id, amenity_id: amenity.id)

      expect(status).to eq(200)
    end
  end
end