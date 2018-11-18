require 'rails_helper'

RSpec.describe 'Lot API', type: :request  do
  # Initialize the test data
  let!(:builder) { create(:builder)}
  let!(:region) { create(:region, builder_id: builder.id)}
  let!(:division) { create(:division, region_id: region.id) }
  let!(:community) { create(:community, division_id: division.id) }
  let(:community_id) {community.id}
  let!(:collection) {create(:collection, region_id: region.id)}
  let!(:plan_style) { create(:plan_style)} 
  let!(:plan) {create(:plan, collection_id: collection.id)}
  let!(:lots) { create_list(:lot, 25, community_id: community.id) }
  let!(:user) { create(:user) }

  let!(:lot_to_test) { lots.sample }
  let!(:id) { lot_to_test.id }
  let(:valid_attributes) { { 
    latitude: Faker::Address.latitude, 
    longitude: Faker::Address.longitude,
    information: Faker::Lorem.paragraph,
    price: Faker::Number.decimal(5,0),
    sqft:  Faker::Number.between(4000,200000),
    community_id: nil,
    name: Faker::Name.name,
    location: Faker::TwinPeaks.location
  }} 
  # Test suite for GET /communities/:community_id/lots
  describe 'GET /communities/:community_id/lots' do
    before { get "/communities/#{community_id}/lots", as: :json }

    context 'when community exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all lots' do
        expect(json['results'].size).to eq(20)
      end
    end

    context 'when community does not exist' do
      let(:community_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Community/)
      end
    end
  end
  # Get all Plans of lot_id 
  describe 'GET /lots/:id/plans' do
    context 'when lot exists' do
      before {
        @lot = lot_to_test
        @lot.plans << plan
        get "/lots/#{@lot.id}/plans", as: :json
      }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all plans' do
        expect(json["results"].size).to eq(1)
      end
    end
    context 'when lot does not exist' do
      before {
        get "/lots/#{id}/plans", as: :json
      }
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Lot/)
      end
    end
  end
  # Test suite for GET /lots/:id
  describe 'GET /lots/:id' do
    before { get "/lots/#{id}", as: :json }

    context 'when the record exists' do
      it 'returns the lot' do
        expect(json).not_to be_empty
        expect(json['name']).to eq(Lot.find(id).name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let!(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Lot/)
      end
    end
  end
  #POST /communities/:community_id/lots
  describe '# POST /communities/:community_id/lots' do 
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
        post "/communities/#{community_id}/lots",  params: valid_attributes
      }
      sign_in :user
      context 'when the request is valid' do
        before { post "/communities/#{community_id}/lots", params: valid_attributes }
        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end
      context 'when an invalid request' do
      
      before { post "/communities/#{community_id}/lots"}

        it 'returns a not found message' do
          expect(response.body).to match(/Latitude can't be blank/)
        end
      end
    end
  end
   # Test suite for PUT /lots/:id
  describe 'PUT /lots/:id' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user
      let(:valid_attributes) { { name: 'Body' } }

      context 'when the record exists' do
        before { put "/lots/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      let(:valid_attribute) { { latitude: '' } }
      context 'when an invalid request' do
      
      before { 
        put "/lots/#{id}", 
                params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Latitude can't be blank/)
        end
      end
    end
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user
      let(:valid_attributes) { { name: 'Body' } }

      context 'when the record exists' do
        before { put "/lots/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end

  # Test suite for DELETE /lots/:id
  describe 'DELETE /lots/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin) 
      }
      sign_in :user

      before { delete "/lots/#{id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user
      before { delete "/lots/#{id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
