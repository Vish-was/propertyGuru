require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Lots" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:community) { create(:community, division_id: division.id) }
  let!(:lots) { create_list(:lot, 25, community_id: community.id) }

  let!(:lot_to_test) { lots.sample }
  let!(:community_id) { community.id }
  let!(:id) { lot_to_test.id }
  let!(:user) { create(:user) }

  let(:page_size) { Faker::Number.between(1, lots.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/communities/:community_id/lots" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "Get all lots" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all lots, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Lot)
      expect(response_size).to eq(paged_size(lots, page_size))
      expect(json['total_count']).to eq(lots.size)
      expect(status).to eq(200)
    end

    example_request "Get all lots, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Lot)
      expect(response_size).to eq(paged_size(lots, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all lots, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Lot)
      expect(response_size).to eq(paged_size(lots, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/lots/:id" do
    example_request "Get a specific lot" do
      expect(status).to eq(200)
    end
  end

  post "/communities/:community_id/lots" do
    before(:each) do
      check_login(user)
    end
    parameter :name
    parameter :latitude
    parameter :longitude
    parameter :information
    parameter :price
    parameter :sqft
    parameter :location 
    parameter :length
    parameter :width
    parameter :setback_front
    parameter :setback_back
    parameter :setback_left
    parameter :setback_right
  
    example_request "Create a new Lot from community" do
      latitude = Faker::Address.latitude 
      longitude = Faker::Address.longitude 
      information = Faker::Lorem.paragraph 
      price = Faker::Number.decimal(5,0) 
      sqft = Faker::Number.between(4000,200000) 
      name = Faker::Name.name
      location = Faker::TwinPeaks.location
      
      do_request( latitude: latitude, longitude: longitude, information: information, 
                  price: price, sqft: sqft, name: name, community_id: community_id, location: location)
      
      expect(status).to eq(201)
    end
  end

  put "/lots/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :setback_right
    parameter :latitude
    parameter :longitude
    parameter :information
    parameter :price
    parameter :sqft

    example_request "Update a price of Lot" do
      name = Faker::Name.name
      do_request(name: name)

      lot = Lot.find(id)
      expect(lot.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/lots/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a Lot" do
      lot_id = create(:lot, name: "Delete me", community_id: community_id).id

      do_request(id: lot_id)

      expect(Lot.where(id: lot_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

  get "/lots/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "Get all plans from lot" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all plans from lot, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from lot, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from lot, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end
end