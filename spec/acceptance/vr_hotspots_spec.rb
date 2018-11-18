require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "VrHotspots" do
  header "Accept", "application/json"

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder: builder) }
  let!(:collection) { create(:collection, region: region) }
  let!(:user) { create(:user) } 
  let!(:user_id) { user.id }
  let!(:plan) { create(:plan, collection: collection) }
  let!(:plan_id) { plan.id }
  let!(:vr_scene) { create(:vr_scene, plan: plan) }
  let(:vr_scene_id) { vr_scene.id }
  let!(:plan_option_set) { create(:plan_option_set, plan: plan) }
  let!(:vr_hotspots) { create_list(:vr_hotspot, 20, vr_scene: vr_scene, plan_option_set: plan_option_set) }
  
  let!(:vr_hotspot_to_test) { vr_hotspots.sample }
  let!(:id) { vr_hotspot_to_test.id }

  let(:page_size) { Faker::Number.between(1, vr_hotspots.size) }
  let(:page_number) { Faker::Number.between(1, 4) }

  get "/vr_scenes/:vr_scene_id/vr_hotspots" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "List all vr_hotspots" do
      do_request

      expect(response_size).to eq(paged_size(vr_hotspots))
      expect(status).to eq(200)
    end

    example "Get all vr_hotspots, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, VrHotspot)
      expect(response_size).to eq(paged_size(vr_hotspots, page_size))
      expect(json['total_count']).to eq(vr_hotspots.size)
      expect(status).to eq(200)
    end

    example_request "Get all vr_hotspots, with paging" do
      do_request(per_page: page_size, page: 2)

      expect(status).to eq(200)
    end

    example_request "Get all vr_hotspots, with random page" do
      do_request(per_page: page_size, page: page_number)

      expect(status).to eq(200)
    end
  end

  get "/vr_hotspots/:id" do
    example_request "Get a specific vr_hotspot" do
      expect(json["name"]).to eq(vr_hotspot_to_test.name)
      expect(status).to eq(200)
    end
  end

  post "/vr_scenes/:vr_scene_id/vr_hotspots" do
    before(:each) do
      check_login(user)
    end
    parameter :name, "name of vr hotspot", required: true
    parameter :vr_scene_id, "ID of the plan option set associatged with the vr scene"
    parameter :plan_option_set_id, "ID of the plan option set associatged with the plan"
    parameter :jump_scene_id
    parameter :position
    parameter :rotation
    parameter :toggle_default
    parameter :type
    parameter :toggle_method
    parameter :show_on_plan_option_id
    parameter :hide_on_plan_option_id
  
    example_request "Create a new vr_hotspot" do
      name = Faker::Name.name 

      do_request( name: name, toggle_default: true, type: "menu" )
      expect(json['name']).to eq(name)
      expect(status).to eq(201)
    end
  end


  put "/vr_hotspots/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :plan_option_set_id, "ID of the plan option set associatged with the plan"
    parameter :name, "name of vr hotspot"

    example_request "Update a vr hotspot" do
      plan_option_set_id = create(:plan_option_set, plan: plan).id
      name = Faker::Beer.name

      do_request(plan_option_set_id: plan_option_set_id, name: name)

      vr_hotspot = VrHotspot.find(id)
      expect(vr_hotspot.plan_option_set_id).to eq(plan_option_set_id)
      expect(vr_hotspot.name).to eq(name)
      expect(status).to eq(204)
    end
  end

  delete "/vr_hotspots/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a vr hotspot" do
      vr_hotspot_id = create(:vr_hotspot, vr_scene_id: vr_scene.id, plan_option_set_id: plan_option_set.id).id

      do_request(id: vr_hotspot_id)

      expect(VrHotspot.where(id: vr_hotspot_id).size).to be(0)
      expect(status).to eq(204)
    end
  end
end