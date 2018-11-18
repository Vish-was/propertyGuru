require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Plans" do
  header "Accept", :format 
  header "Content-Type", "application/json"

  let(:format) { 'application/json' }

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:division) { create(:division, region_id: region.id) } 
  let!(:community) { create(:community, division_id: division.id) }
  let!(:lot) { create(:lot, community_id: community.id)}
  let!(:plan_style) { create(:plan_style) }
  let!(:plans) { create_list(:plan, 25, collection_id: collection.id) }
  
  let!(:plan_to_test) { plans.sample }
  let!(:id) { plan_to_test.id }
  let!(:communities_plan) { create(:communities_plan, community_id: community.id, plan_id: plans.first.id) }
  let!(:user) { create(:user) }
  let(:page_size) { Faker::Number.between(1, plans.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  let(:valid_parameters) {{
      minimum_price: Faker::Number.between(50000,100000),
      maximum_price: Faker::Number.between(150000,400000),
      minimum_size: Faker::Number.between(500,1500),
      maximum_size: Faker::Number.between(1500,4000),
      minimum_bedrooms: Faker::Number.between(0,5),
      minimum_bathrooms: Faker::Number.between(0,5),
      minimum_garages: Faker::Number.between(0,5),
      minimum_stories: Faker::Number.between(0,3)
    }}



  get "/plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    parameter :location, "Location data object to restrict results by"
    parameter :minimum_price, "The minimum base price of plan"
    parameter :maximum_price, "The maximum base price of plan"
    parameter :minimum_size, "The minimum base size of plan in sqft"
    parameter :maximum_size, "The maximum base size of plan in sqft"
    parameter :minimum_bedrooms, "The minimum number of bedrooms of plan"
    parameter :minimum_bathrooms, "The minimum number of bathrooms of plan"
    parameter :minimum_garages, "The minimum number of garage bays of plan"
    parameter :minimum_stories, "The minimum number of stories of plan"
    parameter :downtown_importance, "A number on a scale of 0-100 signifying how important living downtown is to the user"
    parameter :attractions, "An array of attractions a user would want to live near"
    parameter :styles, "An array of home styles the user prefers"

    example "List all plans" do
      do_request

      expect(response_size).to eq(paged_size(plans))
      expect(status).to eq(200)
    end

    example "List all plans with community_base_prices object" do
      do_request
      
      expect(status).to eq(200)
      # expect(json['results'][0]['community_base_prices'][0]['base_price'].to_d).to eq(communities_plan.base_price)
      # expect(json['results'][0]['community_base_prices'][0]['name']).to eq(communities_plan.community.name)
    end

    example "List all plans, restricted by location" do
      do_request(location: "{'bbox': [
                    -95.6980487672028, 
                    33.4335329845548, 
                    -95.3184921619533, 
                    33.8551339899519
                ], 
                'center': [
                    -95.5555, 
                    33.6618
                ], }"
      )
      expect(status).to eq(200)
    end

    example "List all plans, restricted by price" do
      minimum_price = valid_parameters[:minimum_price]
      maximum_price = valid_parameters[:maximum_price]
      scoped_plans = Plan.minimum_price(minimum_price).maximum_price(maximum_price)
      whered_plans = Plan.where('min_price between ? and  ?', minimum_price, maximum_price)

      do_request(minimum_price: minimum_price, maximum_price: maximum_price)
      
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by size" do
      minimum_size = valid_parameters[:minimum_size]
      maximum_size = valid_parameters[:maximum_size]
      do_request(minimum_size: minimum_size, 
                 maximum_size: maximum_size)
      scoped_plans = Plan.minimum_size(minimum_size).maximum_size(maximum_size)
      whered_plans = Plan.where('min_sqft between ? and ?', minimum_size, maximum_size)
      
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by bedrooms" do
      minimum_bedrooms = valid_parameters[:minimum_bedrooms]
      do_request(minimum_bedrooms: minimum_bedrooms)
      scoped_plans = Plan.minimum_bedrooms(minimum_bedrooms)
      whered_plans = Plan.where('min_bedrooms >= ?', minimum_bedrooms)
      
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by bathrooms" do
      minimum_bathrooms = valid_parameters[:minimum_bathrooms]
      do_request(minimum_bathrooms: minimum_bathrooms)
      scoped_plans = Plan.minimum_bathrooms(minimum_bathrooms)
      whered_plans = Plan.where('min_bathrooms >= ?', minimum_bathrooms)

      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by garage size" do
      minimum_garages = valid_parameters[:minimum_garages]
      do_request(minimum_garages: minimum_garages)
      scoped_plans = Plan.minimum_garages(minimum_garages)
      whered_plans = Plan.where('min_garage >= ?', minimum_garages)
       
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by stories" do
      minimum_stories = valid_parameters[:minimum_stories]
      do_request(minimum_stories: minimum_stories)
      scoped_plans = Plan.minimum_stories(minimum_stories)
      whered_plans = Plan.where('min_stories >= ?', minimum_stories)

      expect(response_size).to eq(paged_size(scoped_plans))
      expect(response_size).to eq(paged_size(whered_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by multiple parameters" do
      scoped_plans = Plan.all
      random_parameters = valid_parameters.to_a.sample(4).to_h

      random_parameters.each do |key, value|
        scoped_plans = scoped_plans.public_send(key, value)
      end

      do_request(random_parameters)
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(status).to eq(200)
    end

    example "List all plans, restricted by all parameters" do
      scoped_plans = Plan.all
      valid_parameters.each do |key, value|
        scoped_plans = scoped_plans.public_send(key, value)
      end

      do_request(valid_parameters)
      expect(response_size).to eq(paged_size(scoped_plans))
      expect(status).to eq(200)
    end

    example "Get all plans, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(response_size).to eq(paged_size(plans, page_size))
      expect(json['total_count']).to eq(plans.size)
      expect(status).to eq(200)
    end

    example_request "Get all plans, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(response_size).to eq(paged_size(plans, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all plans, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(response_size).to eq(paged_size(plans, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/plans" do
    let(:format) { 'application/vnd.mhb.v2+json' }

    example_request "Get v2 of API" do
      do_request

      expect(response_body).to include('v2')
      expect(status).to eq(200)
    end
  end

  get "/plans/count" do
    parameter :location, "Location data object to restrict results by"
    parameter :minimum_price, "The minimum base price of plan"
    parameter :maximum_price, "The maximum base price of plan"
    parameter :minimum_size, "The minimum base size of plan in sqft"
    parameter :maximum_size, "The maximum base size of plan in sqft"
    parameter :minimum_bedrooms, "The minimum number of bedrooms of plan"
    parameter :minimum_bathrooms, "The minimum number of bathrooms of plan"
    parameter :minimum_garages, "The minimum number of garage bays of plan"
    parameter :minimum_stories, "The minimum number of stories of plan"
    parameter :downtown_importance, "A number on a scale of 0-100 signifying how important living downtown is to the user"
    parameter :live_near, "An array of amenties a user would want to live near"
    parameter :styles, "An array of home styles the user prefers"

    example_request "Get count of plan results" do
      do_request

      expect(response_body.to_i).to eq(Plan.all.size)
      expect(status).to eq(200)
    end

    example "Get count of plans, restricted by multiple parameters" do
      scoped_plans = Plan.all
      random_parameters = valid_parameters.to_a.sample(3).to_h

      random_parameters.each do |key, value|
        scoped_plans = scoped_plans.public_send(key, value)
      end

      do_request(random_parameters)

      expect(response_body.to_i).to eq(scoped_plans.size)
      expect(status).to eq(200)
    end

  end

  get "/plans/:id" do

    let!(:elevations) { create_list(:elevation, 4, plan: plan_to_test) }
    let!(:plan_image1) { create(:plan_image, story: 1, plan: plan_to_test) }
    let!(:plan_image2) { create(:plan_image, story: 2, plan: plan_to_test) }
    let!(:plan_images) { create_list(:plan_image, 3, plan: plan_to_test) }

    example_request "Get a specific plan" do
      expect(status).to eq(200)
    end
  end

  get "/plans/price_range" do
    example_request "Get a 2D histogram array for the 20 base price buckets for all plans" do

      expect(json.length).to eq(2)
      expect(json["histogram"][0].size).to eq(20)
      expect(json["average"]).to be > 0
      expect(status).to eq(200)
    end
  end

  get "plans/:id/lots" do
    example_request "Get a all lots" do
      expect(status).to eq(200)
    end

    example "Get all lots from plan, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Lot)
      expect(status).to eq(200)
    end

    example_request "Get all lots from plan, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Lot)
      expect(status).to eq(200)
    end

    example_request "Get all lots from plan, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Lot)
      expect(status).to eq(200)
    end
  end

  get "plans/:id/plan_styles" do
    example_request "Get a all plan styles" do
      expect(status).to eq(200)
    end

    example "Get all plan styles from plan, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end

    example_request "Get all plan styles from plan, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end

    example_request "Get all plan styles from plan, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, PlanStyle)
      expect(status).to eq(200)
    end
  end

  get "plans/:id/vr" do
    example_request "Get a all specific plan" do
      expect(status).to eq(200)
    end
  end 

  post "/plans/:id/plan_styles/:plan_style_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Plan"
    parameter :plan_style_id, "id of the PlanStyle"
    

    example_request "Create a new plan_style from plan" do


      do_request(id: id, plan_style_id: plan_style.id)

      expect(status).to eq(200)
    end
  end

  delete "/plans/:id/plan_styles/:plan_style_id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan_style from plan" do

      do_request(id: id, plan_style_id: plan_style.id)

      expect(status).to eq(200)
    end
  end

  get "plans/:id/viewed_users" do
    example_request "Get a all users who viewed this plan" do
      expect(status).to eq(200)
    end

    example "Get a all users who viewed this plan, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end

    example_request "Get a all users who viewed this plan, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end

    example_request "Get a all users who viewed this plan, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, User)
      expect(status).to eq(200)
    end
  end

  # post "/collections/:collection_id/plans" do
  #   before(:each) do
  #     @user = user
  #     @user.add_role(:admin)
  #     allow_any_instance_of(ApplicationController).
  #       to receive(:current_user).and_return(@user)
  #   end
  #   parameter :name, "Name for the Plan", required: true
  #   parameter :location, "Location data object to restrict results by"
  #   parameter :minimum_price, "The minimum base price of plan"
  #   parameter :maximum_price, "The maximum base price of plan"
  #   parameter :minimum_size, "The minimum base size of plan in sqft"
  #   parameter :maximum_size, "The maximum base size of plan in sqft"
  #   parameter :minimum_bedrooms, "The minimum number of bedrooms of plan"
  #   parameter :minimum_bathrooms, "The minimum number of bathrooms of plan"
  #   parameter :minimum_garages, "The minimum number of garage bays of plan"
  #   parameter :minimum_stories, "The minimum number of stories of plan"

  #   example_request "Create a new Plan" do
  #     name = Faker::Company.name 
  #     min_price =  Faker::Number.decimal(6,2)
  #     min_sqft = Faker::Number.between(400,20000)
  #     min_bedrooms = (Faker::Number.between(2,14))/2 
  #     min_bathrooms = (Faker::Number.between(1,10))/2 
  #     min_garage = (Faker::Number.between(2,10))/2  
  #     max_price = Faker::Number.decimal(6,2) 
  #     max_sqft = Faker::Number.between(400,20000) 
  #     max_bedrooms = (Faker::Number.between(2,14))/2 
  #     max_bathrooms = (Faker::Number.between(1,10))/2 
  #     max_garage = (Faker::Number.between(2,10))/2  
  #     image_file_name = Faker::File.file_name 
  #     image_content_type = "image/png" 
  #     image_file_size = Faker::Number.between(10000,500000) 
  #     image_updated_at = DateTime.now 
  #     min_stories = Faker::Number.between(1,4) 
  #     max_stories = Faker::Number.between(4,8) 

  #     do_request( name: name, min_price: min_price, min_sqft: min_sqft, min_bedrooms: min_bedrooms, min_bathrooms: min_bathrooms, min_garage: min_garage, max_price: max_price, max_sqft: max_sqft, max_bedrooms: max_bedrooms, max_bathrooms: max_bathrooms, max_garage: max_garage, image_file_name: image_file_name,image_content_type: image_content_type, image_file_size: image_file_size, image_updated_at: image_updated_at, min_stories: min_stories, max_stories: max_stories, collection_id: collection.id)

  #     expect(json['name']).to eq(name)
  #     expect(status).to eq(201)
  #   end
  # end

  # put "/plans/:id" do
  #   before(:each) do
  #     @user = user
  #     @user.add_role(:admin)
  #     allow_any_instance_of(ApplicationController).
  #       to receive(:current_user).and_return(@user)
  #   end
  #   parameter :name, "Name for the Plan", required: true
  #   parameter :location, "Location data object to restrict results by"
  #   parameter :minimum_price, "The minimum base price of plan"
  #   parameter :maximum_price, "The maximum base price of plan"
  #   parameter :minimum_size, "The minimum base size of plan in sqft"
  #   parameter :maximum_size, "The maximum base size of plan in sqft"
  #   parameter :minimum_bedrooms, "The minimum number of bedrooms of plan"
  #   parameter :minimum_bathrooms, "The minimum number of bathrooms of plan"
  #   parameter :minimum_garages, "The minimum number of garage bays of plan"
  #   parameter :minimum_stories, "The minimum number of stories of plan"

  #   example_request "Rename a Plan" do
  #     name = Faker::Company.name
  #     do_request(name: name)

  #     plan = Plan.find(id)
  #     expect(plan.name).to eq(name)
  #     expect(status).to eq(204)

  #   end
  # end  

  delete "/plans/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan" do
      plan_id = create(:plan, collection_id: collection.id).id

      do_request(id: plan_id)

      expect(Plan.where(id: plan_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

  get "plans/:id/communities" do
    example_request "Get a all communities" do
      expect(status).to eq(200)
    end

    example "Get all communities from plan, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from plan, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from plan, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end
  end

  post "/plans/:id/lots/:lot_id" do
    before(:each) do
      check_login(user)
    end
    parameter :id, "id of the Plan"
    parameter :lot_id, "id of the Lot"
    

    example_request "Create a new lot from plan" do


      do_request(id: id, lot_id: lot.id)

      expect(status).to eq(200)
    end
  end

  delete "/plans/:id/lots/:lot_id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a lot from plan" do

      do_request(id: id, lot_id: lot.id)

      expect(status).to eq(200)
    end
  end
end
