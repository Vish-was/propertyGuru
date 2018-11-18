require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "SavedSearches" do
  header "Accept", "application/json"

  let!(:user) { create(:user) } 
  let!(:user_id) { user.id }
  let!(:saved_searches) { create_list(:saved_search, 50, user: user) }
  
  let!(:saved_search_to_test) { saved_searches.sample }
  let!(:id) { saved_search_to_test.id }

  let(:page_size) { Faker::Number.between(1, saved_searches.size) }
  let(:page_number) { Faker::Number.between(1, 4) }

  get "/users/:user_id/saved_searches" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    before(:each) do
      @user = user
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example "Get all saved searches" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all saved searches, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, SavedSearch)
      expect(response_size).to eq(paged_size(saved_searches, page_size))
      expect(json['total_count']).to eq(saved_searches.size)
      expect(status).to eq(200)
    end

    example_request "Get all saved searches, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, SavedSearch)
      expect(response_size).to eq(paged_size(saved_searches, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all saved searches, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, SavedSearch)
      expect(response_size).to eq(paged_size(saved_searches, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/saved_searches/:id" do
    before(:each) do
      @user = saved_search_to_test.user
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a specific saved search" do
      expect(status).to eq(200)
    end
  end


  post "/users/:user_id/saved_searches" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "User-generated name for the saved search", required: true
    parameter :description, "User-generated description for the saved search"
    parameter :criteria, "JSON object with all search criteria for the saved search", required: true

    example_request "Create a new Saved Search" do
      name = Faker::TwinPeaks.location 
      description = Faker::TwinPeaks.quote
      criteria = '{ "minimum_price": "120000",
                    "attracttions": [
                      23,
                      84
                    ],
                    "downtown_importance": 50,
                    "minimum_bedrooms": 3
                 }'

      do_request( name: name, description: description,
                  criteria: criteria)

      expect(json['name']).to eq(name)
      expect(json['description']).to eq(description)
      expect(json['criteria']).to eq(criteria)
      expect(json['user_id']).to eq(user_id)
      expect(status).to eq(201)
    end
  end
 
  put "/saved_searches/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "User-generated name for the saved search"
    parameter :description, "User-generated description for the saved search"
    parameter :criteria, "JSON object with all search criteria for the saved search"

    example_request "Rename a saved search" do
      name = Faker::TwinPeaks.location
      do_request(name: name)

      saved_search = SavedSearch.find(id)
      expect(saved_search.name).to eq(name)
      expect(saved_search.user_id).to eq(saved_search_to_test.user_id)
      expect(status).to eq(204)

    end
  end

  put "/saved_searches/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "User-generated name for the saved search"
    parameter :description, "User-generated description for the saved search"
    parameter :criteria, "JSON object with all search criteria for the saved search"

    example_request "Rename a saved search" do
      description = Faker::TwinPeaks.quote
      do_request(description: description)

      saved_search = SavedSearch.find(id)
      expect(saved_search.description).to eq(description)
      expect(saved_search.user_id).to eq(saved_search_to_test.user_id)
      expect(status).to eq(204)

    end
  end

  delete "/saved_searches/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a saved search" do
      saved_search_id = create(:saved_search, criteria: "{}", name: "Delete Me!", user_id: user_id).id

      do_request(id: saved_search_id)

      expect(SavedSearch.where(id: saved_search_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

end