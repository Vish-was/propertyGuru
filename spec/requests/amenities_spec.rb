require 'rails_helper'

RSpec.describe 'Amenities API', type: :request do
  # Initialize the test data
  let!(:amenities) { create_list(:amenity, 25) }

  let!(:amenity_to_test) { amenities.sample }
  let!(:id) { amenity_to_test.id }
  let!(:user) { create(:user) }

  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
  }}

  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
  }}

  # Post Create PlansPlanStyles by plan_id and plan_style_id 
  describe 'POST /amenities' do
    
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)     
      }
      sign_in :user
      context 'and when name of amenity exists' do    
        before {
          @amenity = amenity_to_test
          post "/amenities", params: valid_attributes
        }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
        it 'returns the new id' do
          expect(json['id']).to be > 0
        end
        it 'sets the amenity name' do
          expect(Amenity.find(json['id']).name).to eq(valid_attributes[:name])
        end

      end

      context 'and when name of amenity does not exist' do
        
        before {
          post "/amenities", params: { }
        }

        let(:id) { 0 }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when name of amenity exists' do    
        before {
          @amenity = amenity_to_test
          post "/amenities", params: valid_attributes
        }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
        it 'returns the new id' do
          expect(json['id']).to be > 0
        end
        it 'sets the amenity name' do
          expect(Amenity.find(json['id']).name).to eq(valid_attributes[:name])
        end

      end

      context 'and when name of amenity does not exist' do
        
        before {
          post "/amenities", params: { }
        }

        let(:id) { 0 }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
         post "/amenities", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
         post "/amenities", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
   #Get /amenities?starts_with=value
  describe 'GET /amenities?starts_with=:value' do
    
    context 'when value exists' do
      context 'when id exists' do
        before { 
          @amenity = amenity_to_test
          get "/amenities?starts_with=#{@amenity.id}", as: :json 
        }
        it 'returns all amenity' do
          expect(json).not_to be_empty
          expect(json.size).to be > 0
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
      context 'when name exists' do
        before { 
          @amenity = amenity_to_test
          get "/amenities?starts_with=#{@amenity.name}", as: :json 
        }
        it 'returns all amenity' do
          expect(json).not_to be_empty
          expect(json.size).to be > 0
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end