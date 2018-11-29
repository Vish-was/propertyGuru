require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # initialize test data 
  let!(:users) { create_list(:user, 10) }
  let!(:user_to_test) { users.sample }
  let(:id) { user_to_test.id }
  let!(:role) { create(:role)}
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:user_viewed_plan) { create(:user_viewed_plan, user_id: user_to_test.id, plan_id: plan.id) }
  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
    email: Faker::Internet.email,
    image_file_name:  Faker::File.file_name,
    image_content_type: "image/png",
    image_file_size: Faker::Number.between(10000,500000),
    image_updated_at: DateTime.now
  }}


  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    context 'when user is logged in' do
      before { get "/users/#{id}", as: :json }
      sign_in :user_to_test
      context 'when the record exists' do
        

        it 'returns the user' do
          expect(json).not_to be_empty
          expect(json['name']).to eq(User.find(id).name)
          expect(json['email']).to eq(User.find(id).email)
          expect(json['profile']).to eq(User.find(id).profile)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
      context 'when the record does not exist' do
        let(:id) { 0 }
        sign_in :user_to_test

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find User/)
        end
      end
    end
    context 'when user is not current user' do
      before { get "/users/#{id}", as: :json }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end  

  # GET /users/:id/builders
  describe 'GET /users/:id/builders' do
    context 'when user exists' do
      context 'when user is logged in' do
        before { 
          @user = user_to_test
          @user.builders << builder
          get "/users/#{@user.id}/builders", as: :json
        }
        sign_in :user_to_test

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns all builders' do
          expect(json.size).to be > 0
        end
      end
    end
    context 'when user does not exist' do
      before {
        get "/users/#{id}/builders", as: :json
      }

      let(:id) { 0 }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/You need to sign in or sign up before continuing/)
      end
    end
  end
 
  # Get all Users Roles 
  describe 'GET /users/:id/roles' do
    context 'when user exists' do
      context 'when user is logged in' do

        before {
          @user = user_to_test
          @user.roles << role
          get "/users/#{@user.id}/roles", as: :json
        }
        sign_in :user_to_test
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all roles' do
          expect(json["roles"].size).to be > 0
        end
      end
    end

    context 'when user does not exist' do
      before {
        get "/users/#{id}/roles", as: :json
      }

      let(:id) { 0 }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/You need to sign in or sign up before continuing/)
      end
    end
  end
  # Get all User Viewed Plans
  describe 'GET /users/:id/viewed_plans' do
    context 'when user exists' do
      context 'when user is logged in' do

        before {
          @user = user_to_test
          
          get "/users/#{@user.id}/viewed_plans", as: :json
        }
        sign_in :user_to_test
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns all viewed plans' do
          expect(json.size).to be > 0
        end
      end
    end
    context 'when user does not exist' do
      before {
        get "/users/#{id}/viewed_plans", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/You need to sign in or sign up before continuing/)
      end
    end
  end

   # Test suite for GET /users
  describe 'GET /users' do
    # make HTTP get request before each example
    before { get '/users', as: :json }

    it 'returns users' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

   # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'Body' } }
    context 'when the user exists' do
      sign_in :user_to_test
      context 'when the record exists' do
        before {
          @user = user_to_test 
          put "/users/#{@user.id}", params: valid_attributes 
        }

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      let(:valid_attribute) { { email: '' } }
      context 'when an invalid request' do
        before { 
          @user = user_to_test
          put  "/users/#{@user.id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end
    context 'when user does not exist' do
      before {
        put "/users/#{id}", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/You need to sign in or sign up before continuing/)
      end
    end
    context 'when user is not current user' do
      before { put "/users/#{id}", as: :json }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Post Create User viewed Plan by plan_id and user_id 
  describe 'POST /users/:user_id/viewed_plans/:plan_id' do
    context 'and when user does not exist' do
      before {
        post "/users/#{user_id}/viewed_plans/#{plan.id}", as: :json
      }
      let(:user_id) { 0 }
      it 'returns already added message' do
        expect(response.body).to match(/You need to sign in or sign up before continuing/)
      end
    end
    let!(:plan_test) { create(:plan, collection_id: collection.id) }
    context 'and when user exist' do
      context 'when logged in user is admin' do
        context 'when a valid request' do
          before {
            @user = user_to_test
            @user.add_role(:admin)
            post "/users/#{@user.id}/viewed_plans/#{plan_test.id}", as: :json
          }
          sign_in :user_to_test
          it 'should add user viewed plan' do
            expect(response).to have_http_status(201)
          end
        end
        let(:valid_attribute) { { email: '' } }
        context 'when an invalid request' do
          before { 
            @user = user_to_test
            put  "/users/#{@user.id}", params: valid_attribute }
          it 'returns status code 401' do
            expect(response).to have_http_status(401)
          end
        end
      end
      context 'when logged in user is builder' do
        before {
          @user = user_to_test
          @user.add_role(:builder)
          post "/users/#{@user.id}/viewed_plans/#{plan_test.id}", as: :json
        }
        sign_in :user_to_test
        context 'when a valid request' do
          before {
            @user = user_to_test
            @user.add_role(:admin)
            post "/users/#{@user.id}/viewed_plans/#{plan_test.id}", as: :json
          }
          sign_in :user_to_test
          it 'should add user viewed plan' do
            expect(response).to have_http_status(201)
          end
        end
        let(:valid_attribute) { { email: '' } }
        context 'when an invalid request' do
          before { 
            @user = user_to_test
            put  "/users/#{@user.id}", params: valid_attribute }
          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end
        end
      end
    end
  end 
end
