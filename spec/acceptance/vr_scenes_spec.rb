require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "VrScenes" do
  header "Accept", "application/json"

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:user) { create(:user) } 
  let!(:user_id) { user.id }
  let!(:plan) { create(:plan, collection: collection) }
  let!(:plan_id) { plan.id }
  let!(:vr_scenes) { create_list(:vr_scene, 50, plan: plan) }
  
  let!(:vr_scene_to_test) { vr_scenes.sample }
  let!(:id) { vr_scene_to_test.id }

  let(:page_size) { Faker::Number.between(1, vr_scenes.size) }
  let(:page_number) { Faker::Number.between(1, 4) }

  get "/plans/:plan_id/vr_scenes" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "Get all vr scenes" do
      do_request

      expect(response_size).to eq(paged_size(vr_scenes))
      expect(status).to eq(200)
    end

    example_request "Get all vr scenes, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, VrScene)
      expect(response_size).to eq(paged_size(vr_scenes, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all vr scenes, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, VrScene)
      expect(response_size).to eq(paged_size(vr_scenes, page_size, page_number))
      expect(status).to eq(200)
    end
  end
  get "/vr_scenes/:id" do
    example_request "Get a specific vr_scene" do
      expect(json["name"]).to eq(vr_scene_to_test.name)
      expect(status).to eq(200)
    end
  end

  # post "/plans/:plan_id/vr_scenes" do
  #   before(:each) do
  #     @user = user
  #     @user.add_role(:admin)
  #     allow_any_instance_of(ApplicationController).
  #       to receive(:current_user).and_return(@user)
  #   end
  #   parameter :name, "name of vr scene", required: true
  #   parameter :plan_id, "ID of the plan associatged with the collection"
  
  #   example_request "Create a new vr scene" do
  #     scene_name = "Vr_scene"
  
  #     do_request( name: scene_name , plan_id: plan_id )

  #     expect(status).to eq(201)
  #   end
  # end

  put "/vr_scenes/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :plan_id, "ID of the plan associatged with the collection"
    parameter :name, "name of vr scene"

    example_request "Update a vr scene" do
      plan_id = create(:plan, collection: collection).id
      name = Faker::Beer.name

      do_request(plan_id: plan_id, name: name)

      vr_scene = VrScene.find(id)
      expect(vr_scene.plan_id).to eq(plan.id)
      expect(vr_scene.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/vr_scenes/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a vr scene" do
      vr_scene_id = create(:vr_scene, plan_id: plan.id).id

      do_request(id: vr_scene_id)

      expect(VrScene.where(id: vr_scene_id).size).to be(0)
      expect(status).to eq(204)
    end
  end
end