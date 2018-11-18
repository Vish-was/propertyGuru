require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Collections" do
  header "Accept", "application/json"


  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collections) { create_list(:collection, 25, region_id: region.id) }

  let!(:collection_to_test) { collections.sample }
  let!(:plan_style) { create(:plan_style) }
  let!(:plans) { create_list(:plan, 12, collection_id: collection_to_test.id) }

  let!(:region_id) { region.id }
  let!(:id) { collection_to_test.id }
  let!(:user) { create(:user) }
  
  let(:page_size) { Faker::Number.between(1, plans.size) }
  let(:page_number) { Faker::Number.between(1, 10) }


  get "/regions/:region_id/collections" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "Get all collections" do
      do_request

      result_compare_with_db(json, Collection)
      expect(response_size).to eq(paged_size(collections))
      expect(status).to eq(200)
    end

    example "Get all collections, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Collection)
      expect(response_size).to eq(paged_size(collections, page_size))
      expect(json['total_count']).to eq(collections.size)

      expect(status).to eq(200)
    end

    example_request "Get all collections, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Collection)
      expect(response_size).to eq(paged_size(collections, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all collections, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Collection)
      expect(response_size).to eq(paged_size(collections, page_size, page_number))
      expect(status).to eq(200)
    end

  end

  get "/collections/:id" do
    example_request "Get a specific collection" do
      expect(json["name"]).to eq(collection_to_test.name)
      expect(status).to eq(200)
    end
  end

  get "/collections/:id/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all plans for a specific collection" do
      do_request

      result_compare_with_db(json, Plan)
      expect(response_size).to eq(plans.size)
      expect(status).to eq(200)
    end

    example_request "Get all plans for a specific collection, limted by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(response_size).to eq(paged_size(plans, page_size))
      expect(json['total_count']).to eq(plans.size)
      expect(status).to eq(200)
    end

    example_request "Get all plans for a specific collection, with paging" do
      do_request(per_page: page_size, page: page_number)
      
      result_compare_with_db(json, Plan)
      expect(response_size).to eq(paged_size(plans, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  post "/regions/:region_id/collections" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for collection", required: true
    parameter :information, "Information about collection"
    

    example_request "Create a new Collection" do
      name = Faker::Company.name
      information = Faker::Lorem.paragraph
      
      do_request( name: name, information: information)        

      expect(json['name']).to eq(name)
      expect(json['information']).to eq(information)
      expect(status).to eq(201)
    end
  end

  put "/collections/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name for collection", required: true
    parameter :information, "Information about collection"

    example_request "Rename a Collection" do
      name = Faker::Company.name
      do_request(name: name)

      collection = Collection.find(id)
      expect(collection.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/collections/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a Collection" do
      collection_id = create(:collection, name: "Delete Me!", region_id: region_id).id

      do_request(id: collection_id)

      expect(Collection.where(id: collection_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

end