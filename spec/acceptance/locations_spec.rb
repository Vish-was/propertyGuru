require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Locations" do
  let(:test_json) { [1,2,3] }

  before do
    header "Accept", "application/json" 
    allow_any_instance_of(V1::LocationsController).to receive(:index).and_return(test_json)
  end

  get "/locations" do
    parameter :query, "Query string to find locations from", required: true

    example "List top 5 locations that match search string" do
      # do_request(query: "Paris" )
      # expect(status).to eq(200)
    end
  end

  get "/locations/attractions" do
    example "List all attractions a user would want to live near" do
      do_request
      expect(status).to eq(200)
    end
  end

end
