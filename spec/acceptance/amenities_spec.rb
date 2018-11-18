require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Amenities" do
  header "Accept", "application/json"
  
  let!(:amenities) { create_list(:amenity, 25) }

  let!(:amenity_to_test) { amenities.sample }
  let!(:id) { amenity_to_test.id }
  let!(:user) { create(:user) } 

  let(:page_size) { Faker::Number.between(1, amenities.size) }
  let(:page_number) { Faker::Number.between(1, 10) }
  let(:value) { Faker::Name.name }
   
  post "/amenities" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "User-generated name for the Amenity", required: true
  
    example_request "Create a new Amenity" do
      name = Faker::TwinPeaks.location 
     
      do_request( name: name)

      expect(json['name']).to eq(name)
      expect(status).to eq(201)
    end
  end

  get "/amenities?starts_with=:value" do
    
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all amenities with starts with search key by name" do
      expect(status).to eq(200)
    end

    example "Get all amenities, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end

    example_request "Get all amenities, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end

    example_request "Get all amenities, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Amenity)
      expect(status).to eq(200)
    end
  end
end