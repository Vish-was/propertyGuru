require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "PlanOptions" do
  header "Accept", "application/json"
  

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id) }
  let!(:plan_options) { create_list(:plan_option, 20, plan_option_set_id: plan_option_set.id) }
  let!(:division) { create(:division, region_id: region.id)}
  let!(:community) { create(:community, division_id: division.id) }
  let!(:plan_option_to_test) { plan_options.sample }
  let(:plan_option_set_id) { plan_option_set.id }
  let(:id) { plan_option_to_test.id }
  let!(:user) { create(:user) }

  let(:page_size) { Faker::Number.between(1, plan_options.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/plan_option_sets/:plan_option_set_id/plan_options" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    
    example "Get all plan options" do
      do_request

      expect(status).to eq(200)
    end

    example "Get all plan options, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, PlanOption)
      expect(response_size).to eq(paged_size(plan_options, page_size))
      expect(json['total_count']).to eq(plan_options.size)
      expect(status).to eq(200)
    end

    example_request "Get all plan options, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, PlanOption)
      expect(response_size).to eq(paged_size(plan_options, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all plan options, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, PlanOption)
      expect(response_size).to eq(paged_size(plan_options, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/plan_options/:id" do
    example_request "Get a specific plan option" do
      expect(status).to eq(200)
    end
  end

  get "/plan_options/:id/excluded_plan_options" do

    example_request "Get the plan options this plan option excludes" do
      plan_option = create(:plan_option, plan_option_set_id: plan_option_set.id)

      do_request(id: plan_option.id)
      expect(response_size).to eq(0)
      expect(status).to eq(200)
    end

    example_request "Get the plan options this plan option excludes, for non-existent plan option" do
      do_request(id: 0)
      expect(status).to eq(404)
    end

    example_request "Get the plan options this plan option excludes, for option with one exclusion" do

      plan_options = create_list(:plan_option, 2, plan_option_set_id: plan_option_set.id)
      create(:excluded_plan_option, 
             plan_option_id: plan_options[0].id,
             excluded_plan_option_id: plan_options[1].id)
      create(:excluded_plan_option, 
             plan_option_id: plan_options[1].id,
             excluded_plan_option_id: plan_options[0].id)

      do_request(id: plan_options[0].id)
      expect(response_size).to eq(1)
      expect(status).to eq(200)
    end

    example_request "Get the plan options this plan option excludes" do

      num_options = Faker::Number.between(3, 25)
      plan_options = create_list(:plan_option, num_options+1, plan_option_set_id: plan_option_set.id)
      for poid in 1..num_options do
        create(:excluded_plan_option, 
               plan_option_id: plan_options[0].id,
               excluded_plan_option_id: plan_options[poid].id)
        create(:excluded_plan_option, 
               plan_option_id: plan_options[poid].id,
               excluded_plan_option_id: plan_options[0].id)
      end

      do_request(id: plan_options[0].id)
      expect(response_size).to eq(num_options)
      expect(status).to eq(200)
    end
  end

  post "/plan_option_sets/:plan_option_set_id/plan_options" do
    before(:each) do
      check_login(user)
    end
    
    parameter :name, "Optional user-generated name for the  plan option"
    parameter :information, "User-generated information for the plan option"
    parameter :category, "Category for Plan Option "
    parameter :thumbnail_image, "ID of the plan the user is saving", required: true
    parameter :plan_image, "ID of the elevation associatged with the saved plan"
    parameter :plan_option_set_id, "ID of the builder contact associated with the saved plan"
    parameter :default_price, "The original price quoted at the time the build was ordered"
    parameter :type, "The datetime at which the build was ordered"
    parameter :sqft_ac
    parameter :vr_parameter
    parameter :pano_image
    parameter :vr_parameter
    parameter :sqft_living
    parameter :sqft_porch
    parameter :sqft_patio
    parameter :width
    parameter :depth

    example_request "Create a new Plan Option" do
      name = Faker::Space.galaxy  
      thumbnail_image = Rack::Test::UploadedFile.new("#{Rails.root}/public/missing_images/plan_options.png", 'image/png')
      plan_image = Rack::Test::UploadedFile.new("#{Rails.root}/public/missing_images/plan_options.png", 'image/png')
      type = Faker::Lorem.word 
      default_price = Faker::Number.decimal(5,2) 
      category = Faker::Lorem.word 
      sqft_ac =  Faker::Number.between(10,1000) 
      sqft_living = Faker::Number.between(400,20000)
      sqft_porch = Faker::Number.between(400,20000)
      sqft_patio = Faker::Number.between(400,20000)
      width = Faker::Number.between(10,10000)
      depth = Faker::Number.between(10,10000)

      do_request( name: name, category: category,type: type, default_price: default_price, 
                 thumbnail_image: thumbnail_image, plan_image: plan_image, sqft_ac: sqft_ac, 
                 sqft_living: sqft_living, sqft_porch: sqft_porch, sqft_patio: sqft_patio, 
                 width: width, depth: depth)
      expect(json['name']).to eq(name)
      expect(json['category']).to eq(category)
      expect(status).to eq(201)
    end
  end 

  put "/plan_options/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "User-generated name for the saved search"
    parameter :information, "User-generated description for the saved search"
    parameter :category, "JSON object with all search criteria for the saved search"

    example_request "Rename a Plan Option" do
      name = Faker::TwinPeaks.location
      do_request(name: name)

      plan_option = PlanOption.find(id)
      expect(plan_option.name).to eq(name)
      expect(status).to eq(200)
    end
  end
  
  delete "/plan_options/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a Plan Option" do
      plan_option_id = create(:plan_option, plan_option_set_id: plan_option_set_id).id

      do_request(id: plan_option_id)

      expect(PlanOption.where(id: plan_option_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

  get "/plan_options/:id/communities" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example_request "Get all communities from plan_option" do
      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example "Get all communities from plan_option, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from plan_option, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end

    example_request "Get all communities from plan_option, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Community)
      expect(status).to eq(200)
    end
  end
  
  put "/plan_options/:id/communities/:community_id" do
    before(:each) do
     check_login(user)
    end
    parameter :id, "id of the PlanOption"
    parameter :community_id, "id of the Community"
    parameter :base_price, "base price of communities_plans"

    example_request "Update base_price" do
      base_price = Faker::Number.decimal(5, 2)
      do_request(id: id, community_id: community.id, base_price: base_price)
      # expect(status).to eq(200)
    end
  end
end