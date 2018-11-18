require 'rails_helper'

RSpec.describe 'SavedSearches API', type: :request do
  
  let!(:user) { create(:user) }
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) {create(:plan, collection_id: collection.id)}
  let!(:saved_plans) {create_list(:saved_plan, 10, user_id: user.id, plan_id: plan.id)}
  let(:saved_plans_to_test) { saved_plans.sample}
  let(:id) { saved_plans_to_test.id}
  let(:valid_attributes) { { 
    user_id: user.id,
    plan_id: plan.id,
    name: Faker::Beer.name ,
    description: Faker::ChuckNorris.fact 
  }} 
  # Get /user/:user_id/saved_plans
  describe '/users/:user_id/saved_plans' do
    context 'when user is logged in' do
      before { 
        @user = user
      }
      sign_in :user
      context 'when user is current user' do
        context 'and when user exists' do
          before {
            get "/users/#{@user.id}/saved_plans", as: :json
          }
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'returns all saved_plans' do
            expect(json.size).to be > 0
          end
        end
      end
    end
    context 'when user is not current user' do
      before {
          get "/users/#{user.id}/saved_plans", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Get /saved_plans/:id
  describe 'GET /saved_plans/:id' do
    context 'when user is logged in' do
      before { get "/saved_plans/#{id}", as: :json }
      sign_in :user
      context 'when saved_plan exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when saved_plan does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find SavedPlan/)
        end
      end
    end
    context 'when user is not current user' do
      before {
          get "/saved_plans/#{id}", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for POST /users/:user_id/saved_plans
  describe 'POST /users/:user_id/saved_plans' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user

      context 'when the record exists' do
        before { post "/users/#{user.id}/saved_plans", params: valid_attributes }

        it 'create the record' do
          expect(user.reload.saved_plans.length).to eq(11)
        end
      end
      let(:valid_attribute) { { plan_id: '' } }
      context 'when an invalid request' do
      
        before { 
        post "/users/#{user.id}/saved_plans", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Plan can't be blank/)
        end
      end
    end
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user

      context 'when the record exists' do
        before { post "/users/#{user.id}/saved_plans", params: valid_attributes }

        it 'create the record' do
          expect(user.reload.saved_plans.length).to eq(11)
        end
      end
      let(:valid_attribute) { { plan_id: '' } }
      context 'when an invalid request' do
      
        before { 
        post "/users/#{user.id}/saved_plans", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Plan can't be blank/)
        end
      end
    end
    context 'when user is not current user' do
      before {
          post "/users/#{user.id}/saved_plans", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
  
  # Test suite for PUT /saved_plans/:id
  describe 'PUT /saved_plans/:id' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user

      context 'when the record exists' do
        before { put "/saved_plans/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

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

      context 'when the record exists' do
        before { put "/saved_plans/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      let(:valid_attribute) { { plan_id: '' } }
      context 'when an invalid request' do
      
      before { 
        put  "/saved_plans/#{id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Plan can't be blank/)
        end
      end
    end
    context 'when user is not current user' do
      before {
          put  "/saved_plans/#{id}", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # DELETE /saved_plans/:id
  describe 'DELETE /saved_plans/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when saved_plans exists' do
        before {
          @saved_plan = saved_plans_to_test
          delete "/saved_plans/#{@saved_plan.id}"
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
      context 'and when saved_plans exists' do
        before {
          @saved_plan = saved_plans_to_test
          delete "/saved_plans/#{@saved_plan.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
    context 'when user is not current user' do
      before {
         delete "/saved_plans/#{saved_plans_to_test.id}", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end