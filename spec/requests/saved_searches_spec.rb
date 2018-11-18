require 'rails_helper'

RSpec.describe 'SavedSearches API', type: :request do
  
  let!(:user) { create(:user) }
  let!(:saved_searches) {create_list(:saved_search, 11, user_id: user.id)}
  let(:saved_search_to_test) { saved_searches.sample}
  let(:id) { saved_search_to_test.id}
  let(:valid_attributes) { { 
    user_id: user.id,
    name: Faker::Name.name,
    description: Faker::TwinPeaks.quote,
    criteria:  Faker::Number.decimal(5,2)
  }} 
   # Get /user/:user_id/saved_searches
  describe '/users/:user_id/saved_searches' do
    context 'when user is logged in' do
      before { 
        @user = user
      }
      sign_in :user
      context 'when user is current user' do
        context 'and when user exists' do
          before {
            get "/users/#{@user.id}/saved_searches", as: :json
          }
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'returns all saved_searches' do
            expect(json.size).to be > 0
          end
        end
      end
    end
    context 'when user is not current user' do
      before {
          get "/users/#{user.id}/saved_searches", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Get /saved_searches/:id
  describe 'GET /saved_searches/:id' do
    context 'when user is logged in' do
      before { get "/saved_searches/#{id}", as: :json }
      sign_in :user
      context 'when saved_searche exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when saved_searche does not exist' do
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find SavedSearch/)
        end
      end
    end
    context 'when user is not current user' do
      before {
          get "/saved_searches/#{id}", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for POST /users/:user_id/saved_searches
  describe 'POST /users/:user_id/saved_searches' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user

      context 'when the record exists' do
        before { post "/users/#{@user.id}/saved_searches", params: valid_attributes }
        
        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'create the record' do
          expect(user.reload.saved_searches.length).to be > 0
        end
      end

      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        post "/users/#{user.id}/saved_searches", params: valid_attribute }
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

      context 'when the record exists' do
        before { post "/users/#{@user.id}/saved_searches", params: valid_attributes }
        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'create the record' do
          expect(user.reload.saved_searches.length).to be > 0
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
        before { 
        post "/users/#{user.id}/saved_searches", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
    context 'when user is not current user' do
      before {
          post "/users/#{user.id}/saved_searches", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for PUT /builders/:id
  describe 'PUT /saved_searches/:id' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user

      context 'when the record exists' do
        before { put "/saved_searches/#{id}", params: valid_attributes }

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
        before { put "/saved_searches/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'when an invalid request' do
      
      before { 
        put  "/saved_searches/#{id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end

  # DELETE /saved_searches/:id
  describe 'DELETE /saved_searches/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when saved_searches exists' do
        before {
          @saved_searche = saved_search_to_test
          delete "/saved_searches/#{@saved_searche.id}"
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
      context 'and when saved_searches exists' do
        before {
          @saved_searche = saved_search_to_test
          delete "/saved_searches/#{@saved_searche.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
    context 'when user is not current user' do
      before {
         delete "/saved_searches/#{saved_search_to_test.id}", as: :json
      }
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end