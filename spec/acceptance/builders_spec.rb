require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Builders" do
  header "Accept", "application/json"

  let!(:builders) { create_list(:builder, 25) }
  let!(:builder_to_test) { builders.sample }
  let!(:id) { builder_to_test.id }
  let!(:region) { create(:region, builder_id: builder_to_test.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plans) { create_list(:plan, 20, collection_id: collection.id) }
  let!(:collections) { create_list(:collection, 20, region_id: region.id) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:communities) { create_list(:community, 20,division_id: division.id) }
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  let(:page_size) { Faker::Number.between(1, builders.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  let(:page_size) { Faker::Number.between(1, builders.size) }
  let(:page_number) { Faker::Number.between(1, 10) }


  get "/builders" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "List all builders" do
      do_request
  
      expect(status).to eq(200)
    end
    example "Get all builders, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Builder)
      expect(response_size).to eq(paged_size(builders, page_size))
      expect(json['total_count']).to eq(builders.size)

      expect(status).to eq(200)
    end
    example_request "Get all builders, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Builder)
      expect(response_size).to eq(paged_size(builders, page_size, 2))
      expect(status).to eq(200)
    end
    example_request "Get all builders, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Builder)
      expect(response_size).to eq(paged_size(builders, page_size, page_number))
      expect(status).to eq(200)
    end

    example "Get all builders, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Builder)
      expect(status).to eq(200)
    end

    example_request "Get all builders, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Builder)
      expect(status).to eq(200)
    end

    example_request "Get all builders, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Builder)
      expect(status).to eq(200)
    end
  end

  get "/builders/:id/communities" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all communities from builder" do
      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example "Get all communities from builder, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from builder, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from builder, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end
  end

  get "/builders/:id/collections" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all collections from builder" do
      result_compare_with_db(json, Collection)
      expect(status).to eq(200)
    end

    example "Get all collections from builder, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Collection)
      expect(status).to eq(200)
    end

    example_request "Get all collections from builder, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Collection)
      expect(status).to eq(200)
    end

    example_request "Get all collections from builder, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Collection)
      expect(status).to eq(200)
    end
  end

  get "/builders/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all plans from builder" do
      expect(status).to eq(200)
    end

    example "Get all plans from builder, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from builder, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get all plans from builder, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end

  get "/builders/:id" do
    example_request "Get a specific builder" do
      expect(status).to eq(200)
    end
  end

  get "/builders/:id/users" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "Get all users" do
      do_request

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end

    example "Get all users from builder, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end

    example_request "Get all users from builder, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end

    example_request "Get all users from builder, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end
  end

  post "/builders" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for the Builder", required: true
    parameter :production, "production for Builder"
    parameter :website, "website Name for Builder", required: true
    parameter :logo,"Logo of that Builder"
    parameter :about, "Description about builder"
    parameter :locations, "Location for Builder"
    

    example_request "Create a new Builder" do
      name = Faker::Company.name 
      production = Faker::Company.name 
      website = Faker::Lorem.paragraph 
      logo_file_name = Faker::File.file_name 
      logo_content_type = "image/jpeg" 
      logo_file_size = Faker::Number.between(10000,500000) 
      logo_updated_at = DateTime.now 
      about = Faker::Lorem.paragraph 
      locations = Faker::TwinPeaks.location 

      do_request( name: name, production: production,
                  website: website, logo_file_name: logo_file_name, logo_content_type: logo_content_type,
                  logo_file_size: logo_file_size, logo_updated_at: logo_updated_at, about: about, locations: locations)

      expect(json['name']).to eq(name)
      expect(json['website']).to eq(website)
      expect(status).to eq(201)
    end
  end

  put "/builders/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for the Builder", required: true
    parameter :production, "production for Builder"
    parameter :website, "website Name for Builder", required: true
    parameter :logo,"Logo of that Builder"
    parameter :about, "Description about builder"
    parameter :locations, "Location for Builder"

    example_request "Rename a Builder" do
      name = Faker::TwinPeaks.location
      do_request(name: name)

      builder = Builder.find(id)
      expect(builder.name).to eq(name)
      expect(status).to eq(204)

    end
  end

  delete "/builders/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a builder" do
      builder_id = create(:builder).id

      do_request(id: builder_id)

      expect(Builder.where(id: builder_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

  post "/builders/:id/users/:user_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Builder"
    parameter :user_id, "id of the User"
    

    example_request "Create a new user from builder" do


      do_request(id: id, user_id: user.id)

      expect(status).to eq(200)
    end
  end

  delete "/builders/:id/users/:user_id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a user from builder" do

      do_request(id: id, user_id: user.id)

      expect(status).to eq(200)
    end
  end
end