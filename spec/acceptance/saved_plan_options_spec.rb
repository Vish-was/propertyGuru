require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "SavedPlanOptions" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:user) { create(:user) }
  let!(:plan_option_sets) { create_list(:plan_option_set,20, plan_id: plan.id)}
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id)}
  let!(:plan_option) { create(:plan_option, plan_option_set_id: plan_option_set.id) }
  let!(:saved_plan) { create(:saved_plan, plan_id: plan.id, user_id: user.id)}
  let(:saved_plan_id) { saved_plan.id }
  let!(:saved_plan_options) {
    list = [] 
    plan_option_sets.each do |plan_option_set|
      list << create(:saved_plan_option, saved_plan_id: saved_plan.id, plan_option_set_id: plan_option_set.id, plan_option_id: plan_option.id) 
    end
    list
  }
  let!(:user) { create(:user) } 
  let!(:saved_plan_option_to_test) { saved_plan_options.sample }
  let!(:id) { saved_plan_option_to_test.id }

  let(:page_size) { Faker::Number.between(1, saved_plan_options.size) }
  let(:page_number) { Faker::Number.between(1, 10) }


  get "/saved_plans/:saved_plan_id/saved_plan_options" do

    before(:each) do
      check_login(user)
    end
    
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all saved_plan_options" do
      expect(status).to eq(200)
    end

    example "Get all saved_plan_options, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, SavedPlanOption)
      expect(status).to eq(200)
    end

    example_request "Get all saved_plan_options, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, SavedPlanOption)
      expect(status).to eq(200)
    end

    example_request "Get all saved_plan_options, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, SavedPlanOption)
      expect(status).to eq(200)
    end
  end

  get "/saved_plan_options/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Get a specific plan_option_set" do
      expect(status).to eq(200)
    end
  end

  post "/saved_plans/:saved_plan_id/saved_plan_options" do
    before(:each) do
      check_login(user)
    end
    parameter :quoted_price, "horizontal position in 2 dimention"
    parameter :plan_option_set_id, "vertical position in 2 dimention"
    parameter :plan_option_id, "Numbre of stories of plan_option_set"

    example_request "Create a new SavedPlanOption from SavedPlan" do
      quoted_price = Faker::Number.decimal(6,2)
      
      do_request( quoted_price: quoted_price, plan_option_set_id: plan_option_set.id, plan_option_id: plan_option.id, saved_plan_id: saved_plan.id)
      expect(status).to eq(201)
    end
  end

  delete "/saved_plan_options/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a saved_plan_option" do
      do_request(id: saved_plan_option_to_test.id)

      expect(SavedPlanOption.where(id: saved_plan_option_to_test.id).size).to be(0)
    end
  end
end