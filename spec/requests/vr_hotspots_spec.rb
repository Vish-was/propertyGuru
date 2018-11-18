require 'rails_helper'

RSpec.describe 'VrHotspots API', type: :request do

    # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:vr_scene) { create(:vr_scene, plan_id: plan.id)}
  let!(:user) { create(:user) }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id) }
  let!(:vr_hotspots) { create_list(:vr_hotspot,20, vr_scene_id: vr_scene.id, plan_option_set_id: plan_option_set.id)}
  let!(:vr_hotspot_to_test) { vr_hotspots.sample }
  let!(:id) { vr_hotspot_to_test.id }
  let(:vr_scene_id) { vr_scene.id }
  let!(:valid_attributes_create) {{
    plan_option_set_id: nil,
    vr_scene_id: nil,
    jump_scene_id: nil,
    toggle_default: true,
    name:  Faker::Beer.name ,
    type: "menu" ,
    toggle_method:  Faker::Lorem.word,
    show_on_plan_option_id: nil,
    hide_on_plan_option_id: nil
  }}


  let!(:valid_attributes_update) {{
    plan_option_set_id: nil,
    vr_scene_id: nil,
    jump_scene_id: nil,
    toggle_default: true,
    name:  Faker::Beer.name, 
    type: "menu", 
    toggle_method:  Faker::Lorem.word, 
    show_on_plan_option_id: nil,
    hide_on_plan_option_id: nil
  }}
  # GET /vr_scenes/:vr_scene_id/vr_hotspots
  describe '/vr_scenes/:vr_scene_id/vr_hotspots' do
    before {
      @vr_scene = vr_scene
      get "/vr_scenes/#{@vr_scene.id}/vr_hotspots", as: :json
    }

    context 'when vr_scene exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all vr_hotspots' do
        expect(json.size).to be > 0
      end
    end
  end

  # GET /vr_hotspots/:id
  describe 'GET /vr_hotspots/:id' do

    before { get "/vr_hotspots/#{id}", as: :json }

    context 'when vr_hotspot exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when vr_hotspot does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find VrHotspot/)
      end
    end
  end

  # POST /vr_scenes/:vr_scene_id/vr_hotspots
  describe 'POST /vr_scenes/:vr_scene_id/vr_hotspots' do
      context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/vr_scenes/#{vr_scene_id}/vr_hotspots", 
                    params: valid_attributes_create }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the VrHotspot name' do
            expect(VrHotspot.find(json['id']).name).to eq(valid_attributes_create[:name])
          end
        end
        context 'and when request attributes are invalid' do
          before { 
            post "/vr_scenes/#{vr_scene_id}/vr_hotspots", 
                   params: {} 
            }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\"]}")
          end
        end
      end
      context 'when logged in user is builder' do
        before { 
          @user = user
          @user.add_role(:builder)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/vr_scenes/#{vr_scene_id}/vr_hotspots", 
                    params: valid_attributes_create }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the VrHotspot name' do
            expect(VrHotspot.find(json['id']).name).to eq(valid_attributes_create[:name])
          end
        end
        context 'and when request attributes are invalid' do
          before { 
            post "/vr_scenes/#{vr_scene_id}/vr_hotspots", 
                   params: {} 
            }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\"]}")
          end
        end
      end
  end


 # Update PUT /vr_hotspots/:id
   describe 'PUT /vr_hotspots/:id' do
    context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
      sign_in :user
     
     context 'when vr_hotspots exists' do
        before { 
          @vr_hotspot = vr_hotspot_to_test
          put "/vr_hotspots/#{@vr_hotspot.id}", 
               params: valid_attributes_update 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        put "/vr_hotspots/#{vr_hotspot_to_test.id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
    context 'when logged in user is builder' do
        before { 
          @user = user
          @user.add_role(:builder)
        }
      sign_in :user
     
      context 'when vr_hotspots exists' do
        before { 
          @vr_hotspot = vr_hotspot_to_test
          put "/vr_hotspots/#{@vr_hotspot.id}", 
               params: valid_attributes_update 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        put "/vr_hotspots/#{vr_hotspot_to_test.id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end

  # DELETE /vr_hotspots/:id
  describe 'DELETE /vr_hotspots/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when vr_hotspot exists' do
        before {
          @vr_hotspot = vr_hotspot_to_test
          delete "/vr_hotspots/#{@vr_hotspot.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user
      context 'and when vr_hotspot exists' do
        before {
          @vr_hotspot = vr_hotspot_to_test
          delete "/vr_hotspots/#{@vr_hotspot.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
