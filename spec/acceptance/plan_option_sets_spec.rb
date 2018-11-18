require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "PlanOptionSets" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:plan_option_sets) { create_list(:plan_option_set, 25, plan_id: plan.id) }

  let!(:plan_option_set_to_test) { plan_option_sets.sample }
  let!(:id) { plan_option_set_to_test.id }
  let!(:user) { create(:user) } 

  let(:page_size) { Faker::Number.between(1, plan_option_sets.size) }
  let(:page_number) { Faker::Number.between(1, 10) }
  let(:value) { Faker::Name.name }

  get "/plans/:plan_id/plan_option_sets" do
    
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all plan_option_sets" do
      expect(status).to eq(200)
    end

    example "Get all plan_option_sets, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, PlanOptionSet)
      expect(status).to eq(200)
    end

    example_request "Get all plan_option_sets, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, PlanOptionSet)
      expect(status).to eq(200)
    end

    example_request "Get all plan_option_sets, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, PlanOptionSet)
      expect(status).to eq(200)
    end
  end

  get "/plan_option_sets/:id" do
    example_request "Get a specific plan_option_set" do
      expect(status).to eq(200)
    end
  end

  post "/plans/:plan_id/plan_option_sets" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "Name of plan_optioin_set", required: true
    parameter :position_2d_x, "horizontal position in 2 dimention"
    parameter :position_2d_y, "vertical position in 2 dimention"
    parameter :story, "Numbre of stories of plan_option_set"

    example_request "Create a new PlanOptionSet from Plan" do
      name = Faker::Name.name 
      position_2d_x = Faker::Number.decimal(6,2)
      position_2d_y = Faker::Number.decimal(6,2)
      story = Faker::Number.between(1,3)
    
      do_request( name: name, position_2d_x: position_2d_x, position_2d_y: position_2d_y, story: story, plan_id: plan_id)

      expect(json['name']).to eq(name)
      expect(status).to eq(201)
    end
  end

  put "/plan_option_sets/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the PlanOptionSet"
    parameter :name, "Name of plan_optioin_set", required: true
    parameter :position_2d_x, "horizontal position in 2 dimention"
    parameter :position_2d_y, "vertical position in 2 dimention"
    parameter :story, "Numbre of stories of plan_option_set"

    example_request "Update plan_option_set" do
       name = Faker::Name.name 
      position_2d_x = Faker::Number.decimal(6,2)
      position_2d_y = Faker::Number.decimal(6,2)
      story = Faker::Number.between(1,3)
    
      do_request( name: name, position_2d_x: position_2d_x, position_2d_y: position_2d_y, story: story, plan_id: plan_id)

      expect(status).to eq(204)
    end
  end

  delete "/plan_option_sets/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan_option_set" do
      do_request(id: plan_option_set_to_test.id, plan_id: plan_id)

      expect(PlanOptionSet.where(id: plan_option_set_to_test.id).size).to be(0)
    end
  end
end