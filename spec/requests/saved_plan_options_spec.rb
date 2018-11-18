require 'rails_helper'

RSpec.describe 'SavedPlanOptions API', type: :request do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let(:plan_id) { plan.id }
  let!(:user) { create(:user) }
  let!(:plan_option_sets) { create_list(:plan_option_set,20, plan_id: plan.id)}
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id)}
  let!(:plan_option) { create(:plan_option, plan_option_set_id: plan_option_set.id) }
  let!(:saved_plan) { create(:saved_plan, plan_id: plan.id, user_id: user.id)}
  let!(:saved_plan_options) {
    list = [] 
    plan_option_sets.each do |plan_option_set|
      list << create(:saved_plan_option, saved_plan_id: saved_plan.id, plan_option_set_id: plan_option_set.id, plan_option_id: plan_option.id) 
    end
    list
  }


  let!(:saved_plan_option_to_test) { saved_plan_options.sample }
  let!(:id) { saved_plan_option_to_test.id }

  let!(:valid_attributes_create) {{
    quoted_price:  Faker::Number.decimal(5, 2),
    saved_plan_id: saved_plan.id,
    plan_option_id: plan_option.id,
    plan_option_set_id: plan_option_set.id
  }}


  let!(:valid_attributes_update) {{
    quoted_price:  Faker::Number.decimal(5, 2),
    saved_plan_id: saved_plan.id,
    plan_option_set_id: saved_plan_option_to_test.plan_option_set_id
  }}
  # Get /saved_plans/:saved_plan_id/saved_plan_options
  describe '/saved_plans/:saved_plan_id/saved_plan_options' do
    context 'when user is logged in' do
      before { 
        @user = user
      }
      sign_in :user
      context 'when user is current user' do
        context 'and when saved plan exists' do
          before {
            @saved_plan = saved_plan
            get "/saved_plans/#{@saved_plan.id}/saved_plan_options", as: :json
          }
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'returns all saved_plan_options' do
            expect(json.size).to be > 0
          end
        end
      end
    end
    context 'when user is not current user' do
      before {
          @saved_plan = saved_plan
          get "/saved_plans/#{@saved_plan.id}/saved_plan_options", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Get /saved_plan_options/:id
  describe 'GET /saved_plan_options/:id' do

    before { get "/saved_plan_options/#{id}", as: :json }
    context 'when user is logged in' do
      before { 
        @user = user
      }
      sign_in :user
      context 'when saved_plan_options exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when saved_plan_options does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find SavedPlanOption/)
        end
      end
    end
  end

  # POST /saved_plans/:saved_plan_id/saved_plan_options
  describe 'POST /saved_plans/:saved_plan_id/saved_plan_options' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user

      context 'and when request attributes are valid' do
        context 'and when plan_option_set is already added with saved_plan' do
          context 'when an invalid request' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                      params: {} }

            it 'returns status code 422' do
              expect(response).to have_http_status(422)
            end

            it 'returns a failure message' do
              expect(response.body).to match("{\"errors\":[\"Plan option set must exist\",\"Plan option must exist\",\"Plan option can't be blank\"]}")
            end
          end
          context 'when an valid request' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                    params: valid_attributes_update }

            it 'returns status code 204' do
              expect(response).to have_http_status(204)
            end
          end
        end
        context 'and when plan_option_set is not added with saved_plan' do
          context 'and when request attributes are invalid' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                      params: {} }

            it 'returns status code 422' do
              expect(response).to have_http_status(422)
            end

            it 'returns a failure message' do
              expect(response.body).to match("{\"errors\":[\"Plan option set must exist\",\"Plan option must exist\",\"Plan option can't be blank\"]}")
            end
          end
          context 'when an valid request' do
            context 'and when user is current user' do
              before { 
                post "/saved_plans/#{saved_plan.id}/saved_plan_options", params: valid_attributes_create
              }
            

              it 'returns status code 201' do
                expect(response).to have_http_status(201)
              end

              it 'returns the new id' do
                expect(json['id']).to be > 0
              end

              it 'sets the saved plan option quoted_price' do
                expect(SavedPlanOption.find(json['id']).quoted_price).to eq(BigDecimal.new(valid_attributes_create[:quoted_price]))
              end
            end
          end
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
        context 'and when plan_option_set is already added with saved_plan' do
          context 'when an invalid request' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                      params: {} }

            it 'returns status code 422' do
              expect(response).to have_http_status(422)
            end

            it 'returns a failure message' do
              expect(response.body).to match("{\"errors\":[\"Plan option set must exist\",\"Plan option must exist\",\"Plan option can't be blank\"]}")
            end
          end
          context 'when an valid request' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                    params: valid_attributes_update }

            it 'returns status code 204' do
              expect(response).to have_http_status(204)
            end
          end
        end
        context 'and when plan_option_set is not added with saved_plan' do
          context 'and when request attributes are invalid' do
            before { post "/saved_plans/#{saved_plan.id}/saved_plan_options", 
                      params: {} }

            it 'returns status code 422' do
              expect(response).to have_http_status(422)
            end

            it 'returns a failure message' do
              expect(response.body).to match("{\"errors\":[\"Plan option set must exist\",\"Plan option must exist\",\"Plan option can't be blank\"]}")
            end
          end
          context 'when an valid request' do
            context 'and when user is current user' do
              before { 
                post "/saved_plans/#{saved_plan.id}/saved_plan_options", params: valid_attributes_create
              }
            

              it 'returns status code 201' do
                expect(response).to have_http_status(201)
              end

              it 'returns the new id' do
                expect(json['id']).to be > 0
              end

              it 'sets the saved plan option quoted_price' do
                expect(SavedPlanOption.find(json['id']).quoted_price).to eq(BigDecimal.new(valid_attributes_create[:quoted_price]))
              end
            end
          end
        end
      end
    end
    context 'when user is not current user' do
      before {
          @saved_plan = saved_plan
          get "/saved_plans/#{@saved_plan.id}/saved_plan_options", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # DELETE /saved_plan_option/:id
  describe 'DELETE /saved_plan_option/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when saved_plan_options exists' do
        before {
          @saved_plan_option = saved_plan_option_to_test
          delete "/saved_plan_options/#{@saved_plan_option.id}"
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
      context 'and when saved_plan_options exists' do
        before {
          @saved_plan_option = saved_plan_option_to_test
          delete "/saved_plan_options/#{@saved_plan_option.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end