require 'rails_helper'

RSpec.describe 'Builders API', type: :request do
  # initialize test data 
  let!(:builders) { create_list(:builder, 10) }
  let(:builder_to_test) { builders.sample }
  let(:builder_id) { builder_to_test.id }
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
  }}

  # Test suite for GET /builders
  describe 'GET /builders' do
    # make HTTP get request before each example
    before { get '/builders', as: :json }

    it 'returns builders' do
      expect(json).not_to be_empty
      expect(json["results"].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /builders/:id
  describe 'GET /builders/:id' do
    before { get "/builders/#{builder_id}", as: :json }

    context 'when the record exists' do
      it 'returns the builder' do
        expect(json).not_to be_empty
        expect(json['name']).to eq(Builder.find(builder_id).name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:builder_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Builder/)
      end
    end
  end

  # GET /builders/:id/users
  describe 'GET /builders/:id/users' do
    context 'when builder exists' do
      before {
        @builder = builder_to_test
        @builder.users << user
        get "/builders/#{@builder.id}/users", as: :json
      }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all users' do
        expect(json["results"].size).to eq(1)
      end
    end
    context 'when builder does not exist' do
      before {
        get "/builders/#{id}/users", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Builder/)
      end
    end
  end

  # POST /builders/:id/users/:id
  describe 'POST /builders/:id/users/:user_id' do
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when builder exists' do
        context 'and user does not exist' do
         
          before { 
            post "/builders/#{builder_id}/users/#{user_id}", as: :json
          }

          let(:user_id) { 0 }
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find User/)
          end
        end

        context 'and user exist' do

          context 'and user is already added to builder' do

            before {
              @builder = builder_to_test
              @user = user
              @builder.users << @user
              post "/builders/#{@builder.id}/users/#{@user.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/User is already added to builder/)
            end
          end

          context 'and user is not added to builder' do
           
            before {
              @builder = builder_to_test
              @user = user
              post "/builders/#{@builder.id}/users/#{@user.id}", as: :json
            }
    
            it 'should add user to builder' do
              expect(@builder.reload.users.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/User is added to builder/)
            end
          end
        end
      end

      context 'and when builder does not exist' do
        
        before {
          post "/builders/#{builder_id}/users/#{user_id}", as: :json
        }

        let(:builder_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Builder/)
        end
      end
    end
    context 'when logged in user is not admin' do
      
      before { 
        @user = user
         post "/builders/#{builder_id}/users/#{user.id}", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before {
        post "/builders/#{builder_id}/users/#{user.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for POST /builders
  describe 'POST /builders' do
    # valid payload
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
        post '/builders',  params: valid_attributes
      }
      sign_in :user

      let(:valid_attributes) { { name: 'Bob the Builder' } }

      context 'when the request is valid' do
        before { post '/builders', params: valid_attributes }

        it 'creates a builder' do
          expect(json['name']).to eq('Bob the Builder')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/builders', params: { } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Name can't be blank/)
        end
      end
    end
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user

      let(:valid_attributes) { { name: 'Bob the Builder' } }

      context 'when the request is valid' do
        before { post '/builders', params: valid_attributes }

        it 'creates a builder' do
          expect(json['name']).to eq('Bob the Builder')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/builders', params: { } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Name can't be blank/)
        end
      end
    end
  end

    # Delete PlansPlanStyles by plan_id and plan_style_id 
  describe 'DELETE /builders/:builder_id/users/:user_id' do
    
    context 'when logged in user is admin' do

      before { 
        @user = user
        @user.add_role(:admin)

      }
      sign_in :user
      context 'and when builder exists' do
        
        context 'and user does not exist' do
         
          before { delete "/builders/#{builder_id}/users/#{user_id}", as: :json }

          let(:user_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find User/)
          end
        end

        context 'and user exist' do

          context 'and user is already added to builder' do

            before {
              @builder = builder_to_test
              @user = user
              @builder.users << @user
              delete "/builders/#{@builder.id}/users/#{@user.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/User is deleted from builder successfully/)
            end

            it 'should remove user from builder' do
              expect(@builder.reload.users.length).to eq(0)
            end
          end
          context 'and puser is not added to builder' do
            
            before {
              @builder = builder_to_test
              @user = user
              delete "/builders/#{@builder.id}/users/#{@user.id}", as: :json
            }
    
            it 'returns user not added to builder message' do
              expect(response.body).to match(/User does not exist in builder/)
            end
          end
        end
      end
      context 'and when builder does not exist' do
        
        before {
          delete "/builders/#{builder_id}/users/#{user.id}", as: :json
        }

        let(:builder_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end


        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Builder/)
        end
      end
    end
    
    context 'when logged in user is not admin' do
      
      before { 
        @user = user
        # @user.add_role(:admin)
        
        
        delete "/builders/#{builder_id}/users/#{user.id}", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
        delete "/builders/#{builder_id}/users/#{user.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for PUT /builders/:id
  describe 'PUT /builders/:id' do

    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user
      let(:valid_attributes) { { name: 'Body' } }

      context 'when the record exists' do
        before { put "/builders/#{builder_id}", params: valid_attributes }

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
      let(:valid_attributes) { { name: 'Body' } }

      context 'when the record exists' do
        before { put "/builders/#{builder_id}", params: valid_attributes }

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
        put  "/builders/#{builder_id}", params: valid_attribute }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Name can't be blank/)
        end
      end

    end
  end

  # Test suite for DELETE /builders/:id
  describe 'DELETE /builders/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin) 
      }
      sign_in :user

      before { delete "/builders/#{builder_id}" }

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
      before { delete "/builders/#{builder_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
