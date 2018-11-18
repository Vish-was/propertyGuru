require 'rails_helper'

RSpec.describe 'PlanOptionSets API', type: :request do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:plan_option_sets) { create_list(:plan_option_set, 25, plan_id: plan.id) }

  let!(:plan_option_set_to_test) { plan_option_sets.sample }
  let!(:id) { plan_option_set_to_test.id }
  let!(:user) { create(:user) }

  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
    position_2d_x: Faker::Number.decimal(6,2),
    position_2d_y:  Faker::Number.decimal(6,2),
    plan_id: plan.id
  }}
  # Get /plans/:plan_id/plan_option_sets
  describe '/plans/:plan_id/plan_option_sets' do
    before { 
      @plan = plan
      get "/plans/#{@plan.id}/plan_option_sets", as: :json
    }

    context 'when plan exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all plan_option_sets' do
        expect(json["results"].size).to eq(20)
      end
    end
  end

  # Get /plan_option_sets/:id
  describe 'GET /plan_option_sets/:id' do

    before { get "/plan_option_sets/#{id}", as: :json }

    context 'when plan_option_set exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan_option_sets does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find PlanOptionSet/)
      end
    end
  end

  # POST /plans/:plan_id/plan_option_sets
  describe 'POST /plans/:plan_id/plan_option_sets' do
      context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/plans/#{plan_id}/plan_option_sets", 
                    params: valid_attributes }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the plan option sets name' do
            expect(PlanOptionSet.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end
        let(:valid_attribute) { { default_plan_option_id: nil, name: '' } }
        context 'and when request attributes are invalid' do
      
          before { 
           post  "/plans/#{plan_id}/plan_option_sets", params: valid_attribute }

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

        context 'and when request attributes are valid' do
          before { post "/plans/#{plan_id}/plan_option_sets", 
                    params: valid_attributes }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the plan option sets name' do
            expect(PlanOptionSet.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end
        let(:valid_attribute) { { default_plan_option_id: nil, name: '' } }
        context 'and when request attributes are invalid' do
      
          before { 
           post  "/plans/#{plan_id}/plan_option_sets", params: valid_attribute }

           it 'returns a not found message' do
             expect(response.body).to match(/Name can't be blank/)
           end
        end
      end
  end


 # Update PUT /plan_option_sets/:id
   describe 'PUT /plan_option_sets/:id' do
    context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
      sign_in :user
     
     context 'when plan option set exists' do
        before {
          put "/plan_option_sets/#{plan_option_set_to_test.id}", 
               params: valid_attributes 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
      let(:valid_attribute) { {  name: '' } }
        context 'and when request attributes are invalid' do
      
          before { 
           put  "/plan_option_sets/#{plan_option_set_to_test.id}", params: valid_attribute }

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
     
      context 'when plan option set exists' do
        before { 
          @plan_option_set = plan_option_set_to_test
          put "/plan_option_sets/#{@plan_option_set.id}", 
               params: valid_attributes 
        }
         it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
    end
  end

  # DELETE /plan_option_sets/:id
  describe 'DELETE /plan_option_sets/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when plan_option_sets exists' do
        before {
          @plan_option_set = plan_option_set_to_test
          delete "/plan_option_sets/#{@plan_option_set.id}"
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
      context 'and when plan_option_sets exists' do
        before {
          @plan_option_set = plan_option_set_to_test
          delete "/plan_option_sets/#{@plan_option_set.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
