require 'rails_helper'

RSpec.describe 'Collections API', type: :request do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let(:builder_id) { builder.id }

  let!(:region) { create(:region, builder_id: builder.id) }
  let(:region_id) { region.id }

  let!(:collections) { create_list(:collection, 10, region_id: region.id) }
  let!(:collection_to_test) { collections.sample }
  let(:id) { collection_to_test.id }
  let(:name) { collection_to_test.name }
  let(:information) { collection_to_test.information }
  let(:user) { create(:user) }
  let(:plan) { create(:plan, collection_id: collection_to_test.id)}
  # Get all collections
  describe '/regions/:region_id/collections' do
    before { get "/regions/#{region_id}/collections", as: :json }

    context 'when builder and region exist' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all collections' do
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

  # Get a single collection
  describe 'GET /collections/:id' do
    before { get "/collections/#{id}", as: :json }

    context 'when collection exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the collection name' do
        expect(json['name']).to eq(name)
      end
    end

    context 'when collection does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Collection/)
      end
    end
  end

  # GET /collections/:id/plans
  describe 'GET /collections/:id/plans' do

     context 'when collection exists' do
       before { 
        @collection = collection_to_test
        @plan = plan
        get "/collections/#{@collection.id}/plans", as: :json
        }

       it 'returns status code 200' do
         expect(response).to have_http_status(200)
       end

       it 'returns all plans' do
         expect(json["results"].size).to eq(1)
       end
     end
   end



  # Add a new collection
  describe '/regions/:region_id/collections' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      valid_attributes = { 
        name: Faker::Simpsons.character, 
        information: Faker::Lorem.paragraph 
      }

      context 'when request attributes are valid' do
        before { post "/regions/#{region_id}/collections", 
                  params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be > 0
        end

        it 'sets the collection name' do
          expect(Collection.find(json['id']).name).to eq(valid_attributes[:name])
        end

        it 'sets the collection information' do
          expect(Collection.find(json['id']).information).to eq(valid_attributes[:information])
        end

      end

      context 'when an invalid request' do
        before { post "/regions/#{region_id}/collections", 
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
        name: Faker::Simpsons.character, 
        information: Faker::Lorem.paragraph 
      }

      context 'when request attributes are valid' do
        before { post "/regions/#{region_id}/collections", 
                  params: valid_attributes }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new id' do
          expect(json['id']).to be > 0
        end

        it 'sets the collection name' do
          expect(Collection.find(json['id']).name).to eq(valid_attributes[:name])
        end

        it 'sets the collection information' do
          expect(Collection.find(json['id']).information).to eq(valid_attributes[:information])
        end

      end

      context 'when an invalid request' do
        before { post "/regions/#{region_id}/collections", 
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

  # Update a collection
  describe 'PUT /collections/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      valid_attributes = { 
        name: Faker::Simpsons.character, 
        information: Faker::Lorem.paragraph 
      }
      
      before { put "/collections/#{id}", 
                params: valid_attributes }

      context 'when collection exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the collection name' do
          updated_collection = Collection.find(id)
          expect(updated_collection.name).to eq(valid_attributes[:name])
        end

        it 'updates the collection information' do
          updated_collection = Collection.find(id)
          expect(updated_collection.information).to eq(valid_attributes[:information])
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
          put "/collections/#{id}", 
                params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end

      context 'when the collection does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Collection/)
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
        name: Faker::Simpsons.character, 
        information: Faker::Lorem.paragraph 
      }
      
      before { put "/collections/#{id}", 
                params: valid_attributes }

      context 'when collection exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the collection name' do
          updated_collection = Collection.find(id)
          expect(updated_collection.name).to eq(valid_attributes[:name])
        end

        it 'updates the collection information' do
          updated_collection = Collection.find(id)
          expect(updated_collection.information).to eq(valid_attributes[:information])
        end
      end

      context 'when the collection does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Collection/)
        end
      end
    end
  end

  # Delete a collection
  describe 'DELETE /collections/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      before { delete "/collections/#{id}" }

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
      before { delete "/collections/#{id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
