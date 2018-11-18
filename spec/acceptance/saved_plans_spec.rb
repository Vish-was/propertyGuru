require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "SavedPlans" do
  header "Accept", "application/json"

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plans) { create_list(:plan, 20, collection_id: collection.id) }
  let!(:plan_to_test) { plans.sample }
  let!(:plan_option_sets) { create_list(:plan_option_set, 20, plan_id: plan_to_test.id) }
  let!(:plan_option_set_to_test) { plan_option_sets.sample }
  let!(:plan_options) { create_list(:plan_option, 20, plan_option_set_id: plan_option_set_to_test.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id) }
  let!(:plan_option) { create(:plan_option,  plan_option_set_id: plan_option_set.id) }
  let!(:user) { create(:user) } 
  let!(:user_id) { user.id }
  let!(:saved_plans) { create_list(:saved_plan, 50, plan_id: plan.id, user_id: user_id) }

  
  let!(:saved_plan_to_test) { saved_plans.sample }
  let!(:id) { saved_plan_to_test.id }

  let(:page_size) { Faker::Number.between(1, saved_plans.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/users/:user_id/saved_plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    parameter :customized, "Only show customized or non-customized saved plans (value does not matter)"
    parameter :not_customized, "Only show customized or non-customized saved plans (value does not matter)"

    before(:each) do
      @user = user
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example "Get all saved plans" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all customized saved plans for a user" do

      expected = saved_plan_to_test.saved_plan_options.where("saved_plan_options.id IS NOT NULL")
      do_request(customized: "true", per_page: page_size)

      result_compare_with_db(json, SavedPlan)
      expect(response_size).to eq(paged_size(expected, page_size))
      expect(status).to eq(200)
    end

    example "Get all non-customized saved plans for a user" do
     expected = saved_plan_to_test.saved_plan_options.where("saved_plan_options.id IS NULL")
     do_request(not_customized: true, per_page: page_size)

     result_compare_with_db(json, SavedPlan)
     expect(status).to eq(200)
    end

    example "Get all saved plans, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, SavedPlan)
      expect(response_size).to eq(paged_size(saved_plans, page_size))
      expect(json['total_count']).to eq(saved_plans.size)
      expect(status).to eq(200)
    end

    example_request "Get all saved plans, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, SavedPlan)
      expect(response_size).to eq(paged_size(saved_plans, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all saved plans, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, SavedPlan)
      expect(response_size).to eq(paged_size(saved_plans, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/saved_plans/:id" do
    before(:each) do
      @user = saved_plan_to_test.user
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a specific saved plan" do
      expect(status).to eq(200)
    end
  end

  get "/saved_plans/:id" do
    before(:each) do
      @user = saved_plan_to_test.user
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a specific saved plan" do
      expect(status).to eq(200)
    end
  end


  post "/users/:user_id/saved_plans" do

    parameter :plan_id, "ID of the plan the user is saving", required: true
    parameter :elevation_id, "ID of the elevation associatged with the saved plan"
    parameter :contact_id, "ID of the builder contact associated with the saved plan"
    parameter :quoted_price, "The original price quoted at the time the build was ordered"
    parameter :ordered_at, "The datetime at which the build was ordered"
    parameter :completed_at, "The datetime at which the build was completed"
    parameter :name, "Optional user-generated name for the saved plan"
    parameter :description, "User-generated description for the saved search"
    
    before(:each) do
      @user = user
      @user.add_role(:admin)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end

    example_request "Create a new Saved Plan" do
      name = Faker::Space.galaxy 
      description = Faker::TwinPeaks.quote
      do_request( name: name, description: description,
                  plan_id: plan.id, user_id: user.id)

      expect(json['name']).to eq(name)
      expect(json['description']).to eq(description)
      expect(json['plan_id']).to eq(plan_id)
      expect(json['user_id']).to eq(user_id)
      expect(status).to eq(201)
    end
  end

 
  put "/saved_plans/:id" do

    parameter :elevation_id, "ID of the elevation associatged with the saved plan"
    parameter :contact_id, "ID of the builder contact associated with the saved plan"
    parameter :quoted_price, "The original price quoted at the time the build was ordered"
    parameter :ordered_at, "The datetime at which the build was ordered"
    parameter :name, "Optional user-generated name for the saved plan"
    parameter :description, "User-generated description for the saved search"

    before(:each) do
      check_login(user)
    end
    example_request "Update a saved plan" do
      elevation_id = create(:elevation, plan: plan).id
      division = create(:division, region: region)
      contact_id = create(:contact, division: division).id
      quoted_price = plan.min_price + 35654
      name = Faker::Beer.name
      description = Faker::ChuckNorris.fact

      do_request(elevation_id: elevation_id, contact_id: contact_id,
                 quoted_price: quoted_price,
                 name: name, description: description)

      saved_plan = SavedPlan.find(id)
      expect(saved_plan.elevation_id).to eq(elevation_id)
      expect(saved_plan.contact_id).to eq(contact_id)
      expect(saved_plan.quoted_price).to eq(quoted_price)
      expect(saved_plan.plan_id).to eq(saved_plan_to_test.plan_id)
      expect(saved_plan.user_id).to eq(saved_plan_to_test.user_id)
      expect(saved_plan.name).to eq(name)
      expect(saved_plan.description).to eq(description)
      expect(status).to eq(204)
    end

    example_request "Update a saved plan, with an invalid FK" do
      do_request(elevation_id: 0)

      saved_plan = SavedPlan.find(id)
      expect(saved_plan.elevation_id).to be_nil
      expect(status).to eq(422)
    end
  end


  delete "/saved_plans/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a saved plan" do
      saved_plan_id = create(:saved_plan, plan_id: plan.id, name: "Delete Me!", user_id: user.id).id
      do_request(id: saved_plan_id)

      expect(SavedPlan.where(id: saved_plan_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

end