require 'rails_helper'

RSpec.describe 'Regions API' do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:regions) { create_list(:region, 20, builder_id: builder.id) }
  let(:builder_id) { builder.id }
  let(:id) { regions.sample.id }
  let!(:user) { create(:user) }

  # Test suite for GET /builders/:builder_id/regions
  describe 'GET /builders/:builder_id/regions' do
    before { get "/builders/#{builder_id}/regions", as: :json }

    context 'when builder exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all builder regions' do
        expect(json["results"].size).to eq(20)
      end
    end

    context 'when builder does not exist' do
      let(:builder_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Builder/)
      end
    end
  end

  # Test suite for GET /regions/:id
  describe 'GET /regions/:id' do
    before { get "/regions/#{id}", as: :json }

    context 'when builder region exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when builder region does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Region/)
      end
    end
  end

  # Test suite for POST /builders/:builder_id/regions
  describe 'POST /builders/:builder_id/regions' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      let(:valid_attributes) { { name: 'Visit Narnia', done: false } }

      context 'when request attributes are valid' do
        before { post "/builders/#{builder_id}/regions", params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be >= Region.all.count
        end

        it 'sets the collection name' do
          expect(Region.find(json['id']).name).to eq(valid_attributes[:name])
        end
      end

      context 'when an invalid request' do
        before { post "/builders/#{builder_id}/regions", params: {} }

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
      let(:valid_attributes) { { name: 'Visit Narnia', done: false } }

      context 'when request attributes are valid' do
        before { post "/builders/#{builder_id}/regions", params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be >= Region.all.count
        end

        it 'sets the collection name' do
          expect(Region.find(json['id']).name).to eq(valid_attributes[:name])
        end
      end

      context 'when an invalid request' do
        before { post "/builders/#{builder_id}/regions", params: {} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end

  # Test suite for PUT /regions/:id
  describe 'PUT /regions/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      let(:valid_attributes) { { name: 'Mozart' } }

      before { put "/regions/#{id}", params: valid_attributes }

      context 'when region exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the region' do
          updated_region = Region.find(id)
          expect(updated_region.name).to match(/Mozart/)
        end
      end

      context 'when the region does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Region/)
        end
      end
      let(:valid_attribute) { { name: '' } }
     context 'when an invalid request' do
       before { 
          put "/regions/#{id}", 
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
      let(:valid_attributes) { { name: 'Mozart' } }

      before { put "/regions/#{id}", params: valid_attributes }

      context 'when region exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the region' do
          updated_region = Region.find(id)
          expect(updated_region.name).to match(/Mozart/)
        end
      end

      context 'when the region does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Region/)
        end
      end
    end
  end

  # Test suite for DELETE /regions/:id
  describe 'DELETE /regions/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      before { delete "/regions/#{id}" }

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
      before { delete "/regions/#{id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
