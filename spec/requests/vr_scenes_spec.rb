require 'rails_helper'

RSpec.describe 'VrScenes API', type: :request do

  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:user) { create(:user) }
  let!(:vr_scenes) { create_list(:vr_scene,20, plan_id: plan.id)}
  let!(:vr_scene_to_test) { vr_scenes.sample }
  let!(:id) { vr_scene_to_test.id }

  let!(:valid_attributes_create) {
     {
    name: Faker::Beer.name,
    plan_id: plan.id
  }}


  let!(:valid_attributes_update) {
     {
    name: Faker::Beer.name,
    plan_id: plan.id
  }}
  # GET /plans/:plan_id/vr_scenes
  describe '/plans/:plan_id/vr_scenes' do
    before {
      @plan = plan
      get "/plans/#{@plan.id}/vr_scenes", as: :json
    }

    context 'when plan exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all vr_scenes' do
        expect(json["results"].size).to eq(20)
      end
    end
  end

  # GET /vr_scenes/:id
  describe 'GET /vr_scenes/:id' do

    before { get "/vr_scenes/#{id}", as: :json }

    context 'when vr_scenes exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when vr_scenes does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find VrScene/)
      end
    end
  end

  # POST /plans/:plan_id/vr_scenes
  describe 'POST /plans/:plan_id/vr_scenes' do
      context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/plans/#{plan_id}/vr_scenes", 
                    params: valid_attributes_create }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the VrScene name' do
            expect(VrScene.find(json['id']).name).to eq(valid_attributes_create[:name])
          end
        end
        context 'and when request attributes are invalid' do
          before { 
            post "/plans/#{plan_id}/vr_scenes", 
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
          before { post "/plans/#{plan_id}/vr_scenes", 
                    params: valid_attributes_create }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the VrScene name' do
            expect(VrScene.find(json['id']).name).to eq(valid_attributes_create[:name])
          end
        end
        context 'and when request attributes are invalid' do
          before { 
            post "/plans/#{plan_id}/vr_scenes", 
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


 # Update PUT /vr_scenes/:id
   describe 'PUT /vr_scenes/:id' do
    context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
      sign_in :user
     
     context 'when vr_scenes exists' do
        before { 
          @vr_scene = vr_scene_to_test
          put "/vr_scenes/#{@vr_scene.id}", 
               params: valid_attributes_update 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        put "/vr_scenes/#{vr_scene_to_test.id}", params: valid_attribute }
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
     
      context 'when vr_scenes exists' do
        before { 
          @vr_scene = vr_scene_to_test
          put "/vr_scenes/#{@vr_scene.id}", 
               params: valid_attributes_update 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        put "/vr_scenes/#{vr_scene_to_test.id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end

  # DELETE /vr_scenes/:id
  describe 'DELETE /vr_scenes/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when vr_scene exists' do
        before {
          @vr_scene = vr_scene_to_test
          delete "/vr_scenes/#{@vr_scene.id}"
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
      context 'and when vr_scene exists' do
        before {
          @vr_scene = vr_scene_to_test
          delete "/vr_scenes/#{@vr_scene.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
