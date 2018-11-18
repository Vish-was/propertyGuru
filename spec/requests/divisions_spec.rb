require 'rails_helper'

RSpec.describe 'Divisions API', type: :request do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let(:builder_id) { builder.id }

  let!(:region) { create(:region, builder_id: builder.id) }
  let(:region_id) { region.id }

  let!(:divisions) { create_list(:division, 10, region_id: region.id) }
  let!(:division_to_test) { divisions.sample }
  let!(:community) { create(:community, division_id: division_to_test.id) }
  let(:id) { division_to_test.id }
  let(:name) { division_to_test.name }
  let!(:lot) { create(:lot, community_id: community.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) { create(:plan, collection_id: collection.id)}
  let(:plan_name){plan.name}

  let!(:user) { create(:user) }

  # Get all divisions
  describe '/regions/:region_id/divisions' do
    before { get "/regions/#{region_id}/divisions", as: :json }

    context 'when region exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all divisions' do
        expect(json["results"].size).to eq(10)
      end
    end

    context 'when region does not exist' do
      let(:region_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Region/)
      end
    end
  end

  # Get a single division
  describe 'GET /divisions/:id' do
    before { get "/divisions/#{id}", as: :json }

    context 'when division exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the division name' do
        expect(json['name']).to eq(name)
      end
    end

    context 'when division does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Division/)
      end
    end
  end

  #Get divisions/x/plans?starts_with = name
  describe 'GET /divisions/:id/plans?starts_with =:plan_name' do
    
    context 'when division id exists' do
       before { 
        @division = division_to_test
      }
      context "and when plan name exists" do
        before { 
          @plan = plan
          get "/divisions/#{@division.id}/plans?starts_with=#{@plan.name}", as: :json
        }
        it 'returns all plans' do
          expect(json).not_to be_empty
          expect(json.size).to be > 0
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
    context 'when division id does not exist' do
      before { 
        @plan = plan
        get "/divisions/#{id}/plans?starts_with=#{@plan.name}", as: :json
      }

      let(:id) {  }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Division/)
      end
    end
  end
  # Add a new division
  describe '/regions/:region_id/divisions' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      valid_attributes = { 
        name: Faker::Simpsons.character 
      }

      context 'when request attributes are valid' do
        before { post "/regions/#{region_id}/divisions", 
                  params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be > 0
        end

        it 'sets the division name' do
          expect(Division.find(json['id']).name).to eq(valid_attributes[:name])
        end
      end

      context 'when an invalid request' do
        before { post "/regions/#{region_id}/divisions", 
                  params: {} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
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
      valid_attributes = { 
        name: Faker::Simpsons.character 
      }

      context 'when request attributes are valid' do
        before { post "/regions/#{region_id}/divisions", 
                  params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be > 0
        end

        it 'sets the division name' do
          expect(Division.find(json['id']).name).to eq(valid_attributes[:name])
        end
      end

      context 'when an invalid request' do
        before { post "/regions/#{region_id}/divisions", 
                  params: {} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end

  # Update a division
  describe 'PUT /divisions/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      valid_attributes = { 
        name: Faker::Simpsons.character 
      }
      
      before { put "/divisions/#{id}", 
                params: valid_attributes }

      context 'when division exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the division name' do
          updated_division = Division.find(id)
          expect(updated_division.name).to eq(valid_attributes[:name])
        end
      end

      context 'when the division does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Division/)
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
      before { 
        put "/divisions/#{id}", 
                params: valid_attribute }
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
      valid_attributes = { 
        name: Faker::Simpsons.character 
      }
      
      before { put "/divisions/#{id}", 
                params: valid_attributes }

      context 'when division exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the division name' do
          updated_division = Division.find(id)
          expect(updated_division.name).to eq(valid_attributes[:name])
        end
      end

      context 'when the division does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Division/)
        end
      end
    end
  end

  # Delete a division
  describe 'DELETE /divisions/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when division exists' do

        before { 
          @division = division_to_test
          delete "/divisions/#{@division.id}"
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
      context 'and when division exists' do

        before { 
          @division = division_to_test
          delete "/divisions/#{@division.id}"
        }

        it 'returns status code 204' do
           expect(response).to have_http_status(204)
         end
      end
    end
  end
end
