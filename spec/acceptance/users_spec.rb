require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder)}
  let!(:users) { create_list(:user, 25) }
  let!(:user_to_test) { users.sample }
  let!(:id) { user_to_test.id }

  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:division) { create(:division, region_id: region.id) } 
  let!(:community) { create(:community, division_id: division.id) }
  let!(:lot) { create(:lot, community_id: community.id)}
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:user_viewed_plan) { create(:user_viewed_plan, plan_id: plan_id, user_id: id) }

  let(:page_size) { Faker::Number.between(1, users.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  let(:valid_parameters) {{
      name_like: user_to_test.name,
      email_like: user_to_test.email,
  }}

  get "/users" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    parameter :email_like, "Search by email substring"
    parameter :name_like, "Search by name substring"

    example "List all users" do
      do_request
      expect(response_size).to eq(paged_size(users))
      expect(status).to eq(200)
    end

    example "List all users, with exact email address" do
      do_request(email_like: user_to_test.email)
      expect(response_size).to eq(1)
      expect(status).to eq(200)
    end

    example "List all users, restricted by email substring" do
      email_substring = '.com'
      scoped_users = User.email_like(email_substring)
      whered_users = User.where("email ilike ?", "%#{email_substring}%")

      do_request(email_like: email_substring)
      expect(response_size).to eq(paged_size(scoped_users))
      expect(response_size).to eq(paged_size(whered_users))
      expect(json["results"][0]['email']).to include(email_substring) if response_size > 0
      expect(status).to eq(200)
    end

    example "List all users, with exact name" do
      name = user_to_test.name
      scoped_users = User.name_like(name)
      whered_users = User.where("name = ?", name)

      do_request(name_like: name) 
      expect(response_size).to eq(paged_size(scoped_users))
      expect(response_size).to eq(paged_size(whered_users))
      expect(json["results"][0]['name']).to eq(name) if response_size > 0
      expect(status).to eq(200)
    end

    example "List all users, restricted by name substring" do
      name_substring = 'Jo'
      scoped_users = User.name_like(name_substring)
      whered_users = User.where("name ilike ?", "%#{name_substring}%")

      do_request(name_like: name_substring)
      expect(response_size).to eq(paged_size(scoped_users))
      expect(response_size).to eq(paged_size(whered_users))
      expect(json["results"][0]['name'].downcase).to include(name_substring.downcase) if response_size > 0
      expect(status).to eq(200)
    end

    example "List all users, restricted by multiple parameters" do
      scoped_users = User.all
      random_parameters = valid_parameters.to_a.sample(2).to_h

      random_parameters.each do |key, value|
        scoped_users = scoped_users.public_send(key, value)
      end

      do_request(random_parameters)
      expect(response_size).to eq(paged_size(scoped_users))
      expect(status).to eq(200)
    end

    example "List all users, restricted by all parameters" do
      scoped_users = User.all
      valid_parameters.each do |key, value|
        scoped_users = scoped_users.public_send(key, value)
      end

      do_request(valid_parameters)
      expect(response_size).to eq(paged_size(scoped_users))
      expect(status).to eq(200)
    end

    example "Get all users, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, User)
      expect(response_size).to eq(paged_size(users, page_size))
      expect(json['total_count']).to eq(users.size)
      expect(status).to eq(200)
    end

    example_request "Get all users, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, User)
      expect(response_size).to eq(paged_size(users, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all users, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, User)
      expect(response_size).to eq(paged_size(users, page_size, page_number))
      expect(status).to eq(200)
    end

  end

  get "/users/:id" do
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a specific user" do
      expect(status).to eq(200)
    end
  end

  put "/users/:id" do
    parameter :name, "Full name to change"
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Update user name" do
      new_name = Faker::Name.name
      do_request(name: new_name)

      expect(User.find(id).name).to eq(new_name)
      expect(status).to eq(204)
    end

    example_request "Update user profile" do
      new_profile = "{'name': 'value'}"
      do_request(profile: new_profile)

      expect(User.find(id).profile).to eq(new_profile)
      expect(status).to eq(204)
    end

  end

  get "/users/:id/builders" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example "Get all builders" do
      do_request

      result_compare_with_db(json, Builder)
      expect(status).to eq(200)
    end
  end

  get "users/:id/viewed_plans" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a all plans viewed by user" do
      expect(status).to eq(200)
    end

    example "Get a all plans viewed by user, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get a all plans viewed by user, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end

    example_request "Get a all plans viewed by user, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Plan)
      expect(status).to eq(200)
    end
  end

  post "/users/:id/viewed_plans/:plan_id" do
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    parameter :id, "id of the User which is currently logged in"
    parameter :plan_id, "id of the Plan"
    

    example_request "Create a new user viewed plan" do

      do_request(id: @user.id, plan_id: plan_id)

      expect(json['user_id']).to eq(@user.id)
      expect(json['plan_id']).to eq(plan_id)
      expect(status).to eq(201)
    end
  end

  get "/users/:id/roles" do
    before(:each) do
      @user = user_to_test
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(@user)
    end
    example_request "Get a specific user roles" do
      expect(status).to eq(200)
    end
  end
end