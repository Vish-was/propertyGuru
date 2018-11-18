require 'rails_helper'

RSpec.describe 'PlanOption API' do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:community) { create(:community, division_id: division.id) }
  let(:community_id) { community.id}
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id) }
  let(:plan_option_set_id) { plan_option_set.id}
  let!(:plan_options) { create_list(:plan_option, 20, plan_option_set_id: plan_option_set.id) }


  let!(:plan_option_to_test) { plan_options.sample }
  let(:plan_id) { plan.id }
  let!(:id) { plan_option_to_test.id }
  let!(:community_plan_option) { create(:community_plan_option, plan_option_id: plan_option_to_test.id, community_id: community.id) }
  let!(:user) { create(:user) }
  let!(:valid_attributes) {{
    name: Faker::Space.galaxy, 
    information:  Faker::Lorem.sentence, 
    default_price:  Faker::Number.decimal(5,2), 
    category:  Faker::Lorem.word, 
    sqft_ac:  Faker::Number.between(10,1000),  
    thumbnail_image:  Rack::Test::UploadedFile.new("#{Rails.root}/public/missing_images/plan_options.png", 'image/png'), 
    plan_image: Rack::Test::UploadedFile.new("#{Rails.root}/public/missing_images/plan_options.png", 'image/png'), 
    pano_image:  Faker::Internet.url, 
    vr_parameter: Faker::Lorem.sentence,
    type: Faker::Lorem.word,
    sqft_living:  Faker::Number.between(400,20000),
    sqft_porch:  Faker::Number.between(400,20000),
    sqft_patio:  Faker::Number.between(400,20000),
    width:  Faker::Number.between(10,10000),
    depth:  Faker::Number.between(10,10000),
    plan_option_set_id: plan_option_set.id
  }}
  # Test suite for GET /plans/:plan_id/plan_option
  describe 'GET /plan_option_sets/:plan_option_set_id/plan_options' do
    before { get "/plan_option_sets/#{plan_option_set_id}/plan_options", as: :json }

    context 'when plan option set exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all plan options' do
        expect(json["results"].size).to eq(20)
      end
    end

    context 'when plan option set does not exist' do
      let(:plan_option_set_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find PlanOptionSet/)
      end
    end
  end

  # Test suite for GET /plans/:plan_id/plan_option/:id
  describe 'GET /plan_options/:id' do
    before { get "/plan_options/#{id}", as: :json }

    context 'when plan option exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan option does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find PlanOption/)
      end
    end
  end

  # Test suite for GET /plan_options/:id/communities
  describe 'GET /plan_options/:id/communities' do

    context 'when plan_option exists' do
      before {
        @plan_option = plan_option_to_test
        get "/plan_options/#{@plan_option.id}/communities", as: :json
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan_option does not exist' do
      before {
        get "/plan_options/#{id}/communities", as: :json
      }

      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find PlanOption/)
      end
    end
  end

  # Update CommunityPlanOptions by plan_option_id and community_id 
  describe 'PUT /plan_options/:id/communities/:community_id' do
    let(:valid_attributes) { { base_price: 200 } }
    context 'when logged in user is admin' do
      before {
        @user = user
        @user.add_role(:admin) 
      }
      sign_in :user
      context 'when plan option exists' do
        context 'and community does not exist' do
          before { put "/plan_options/#{id}/communities/#{community_id}", params: valid_attributes }

          let(:community_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Community/)
          end
        end

        context 'and community exist' do

          context 'and community is already added to plan option' do

            before {
              @plan_option = plan_option_to_test
              @community = community
              put "/plan_options/#{@plan_option.id}/communities/#{@community.id}", params: valid_attributes
            }
    
            it 'returns updated message' do
              expect(response.body).to match(/Community is updated from plan option successfully/)
            end

            it 'should update community from plan option' do
              @community_plan_option = @plan_option.community_plan_options.where('community_id = ?', @community.id).update(valid_attributes)
              # expect(@community_plan_option.base_price).to match(200)
            end

          end

          context 'and community is not added to plan option' do
            before {
              @plan_option = plan_option_to_test
              @community = community
              put "/plan_options/#{@plan_option.id}/communities/#{@community.id}", params: valid_attributes
            }
    
            # it 'returns community is not added to plan option message' do
            #   expect(response.body).to match(/Community does not exist in plan option/)
            # end
          end
        end
      end

      context 'when plan option does not exist' do
        before {
          put "/plan_options/#{id}/communities/#{community.id}", params: valid_attributes
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find PlanOption/)
        end
      end
    end
    context 'when logged in user is builder' do
      before { 
        @user = user
        @user.add_role(:builder) 
      }
      sign_in :user
      context 'when plan option exists' do
        context 'and community does not exist' do
          before { put "/plan_options/#{id}/communities/#{community_id}", params: valid_attributes }

          let(:community_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Community/)
          end
        end

        context 'and community exist' do

          context 'and community is already added to plan option' do

            before {
              @plan_option = plan_option_to_test
              @community = community
              put "/plan_options/#{@plan_option.id}/communities/#{@community.id}", params: valid_attributes
            }
    
            it 'returns updated message' do
              expect(response.body).to match(/Community is updated from plan option successfully/)
            end

            it 'should update community from plan option' do
              @community_plan_option = @plan_option.community_plan_options.where('community_id = ?', @community.id).update(valid_attributes)
              # expect(@community_plan_option.base_price).to match(200)
            end

          end

          context 'and community is not added to plan option' do
            before {
              @plan_option = plan_option_to_test
              @community = community
              put "/plan_options/#{@plan_option.id}/communities/#{@community.id}", params: valid_attributes
            }
    
            # it 'returns community is not added to plan option message' do
            #   expect(response.body).to match(/Community does not exist in plan option/)
            # end
          end
        end
      end

      context 'when plan option does not exist' do
        before {
          put "/plan_options/#{id}/communities/#{community.id}", params: valid_attributes
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find PlanOption/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
       
       before { 
         @user = user
          put "/plan_options/#{id}/communities/#{community_id}"
       }
       sign_in :user

       it 'returns status code 403' do
         expect(response).to have_http_status(403)
       end
    end

    context 'when user is not logged in' do
     
      before {
          put "/plan_options/#{id}/communities/#{community_id}"
       }
       
       it 'returns status code 401' do
         expect(response).to have_http_status(401)
       end
    end
  end

  # # Test suite for POST /plan_option_sets/:plan_option_set_id/plan_option
  describe 'Create plan option under plan' do
  
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'create plan option' do
        before do
          post "/plan_option_sets/#{plan_option_set.id}/plan_options", params: valid_attributes
        end

        it 'should save plan option' do
          expect(response).to have_http_status(201)
        end
      end
    end
   context 'when builder logged in' do
      before do
        @user = user
        @user.add_role(:builder)
      end

      sign_in :user

      context 'create plan option' do
        before do
          post "/plan_option_sets/#{plan_option_set.id}/plan_options", params: valid_attributes
        end

        it 'should save plan option' do
          expect(response).to have_http_status(201)
        end
      end
    end
   context 'when regular user log in' do
      before do
        @user = user
      end

      sign_in :user

      context 'create plan option' do
        before do
          post "/plan_option_sets/#{plan_option_set.id}/plan_options", params: valid_attributes
        end

        it 'should return forbidden' do
          expect(response).to have_http_status(403)
        end
      end
    end
   #   let(:valid_attributes) { { name: 'Visit Narnia', done: false } }

  #   context 'when request attributes are valid' do
  #     before { post "/plans/#{plan_id}/plan_option", params: valid_attributes }

  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end

  #     it 'returns the new id' do
  #       expect(json['id']).to be >= Region.all.count
  #     end

  #     it 'sets the collection name' do
  #       expect(Region.find(json['id']).name).to eq(valid_attributes[:name])
  #     end
  end
  # Update PUT /plan_options/:id
  describe 'Updaing existing plan option' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user
      context 'and when request attributes are valid' do
        context 'update plan option' do
          before do
            put "/plan_options/#{id}", params: { name: 'Test' }
          end

          it 'should save plan_option' do
            expect(response).to have_http_status(200)
            plan_option_to_test.reload
            expect(plan_option_to_test.name).to eq('Test')
          end
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'and when request attributes are invalid' do
    
        before { 
         put  "/plan_options/#{id}", params: valid_attribute }

         it 'returns a not found message' do
           expect(response.body).to match(/Name can't be blank/)
         end
      end
    end
    context 'when builder logged in' do
      before do
        @user = user
        @user.add_role(:builder)
      end

      sign_in :user

      context 'and when request attributes are valid' do
        context 'update plan option' do
          before do
            put "/plan_options/#{id}", params: { name: 'Test' }
          end

          it 'should save plan_option' do
            expect(response).to have_http_status(200)
            plan_option_to_test.reload
            expect(plan_option_to_test.name).to eq('Test')
          end
        end
      end
      let(:valid_attribute) { { name: '' } }
      context 'and when request attributes are invalid' do
    
        before { 
         put  "/plan_options/#{id}", params: valid_attribute }

         it 'returns a not found message' do
           expect(response.body).to match(/Name can't be blank/)
         end
      end
    end
  end
  # DELETE /plan_options/:id
  describe 'Delete existing plan option' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'delete plan option' do
        before do 
          @plan_option = plan_option_to_test
          delete "/plan_options/#{@plan_option.id}"
        end

        it 'should save plan option' do
          #expect(response).to have_http_status(204)
        end
      end
    end
    context 'when builder logged in' do
      before do
        @user = user
        @user.add_role(:builder)
      end

      sign_in :user

      context 'delete plan option' do
        before do 
          @plan_option = plan_option_to_test
          delete "/plan_options/#{@plan_option.id}"
        end

        it 'should save plan option' do
          #expect(response).to have_http_status(204)
        end
      end
    end
  end


  #   context 'when an invalid request' do
  #     before { post "/plans/#{plan_id}/plan_option", params: {} }

  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'returns a failure message' do
  #       expect(response.body).to match(/Validation failed: Name can't be blank/)
  #     end
  #   end
  # end

  # # Test suite for PUT /plans/:plan_id/plan_option/:id
  # describe 'PUT /plans/:plan_id/plan_option/:id' do
  #   let(:valid_attributes) { { name: 'Mozart' } }

  #   before { put "/plans/#{plan_id}/plan_option/#{id}", params: valid_attributes }

  #   context 'when region exists' do
  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end

  #     it 'updates the region' do
  #       updated_region = Region.find(id)
  #       expect(updated_region.name).to match(/Mozart/)
  #     end
  #   end

  #   context 'when the region does not exist' do
  #     let(:id) { 0 }

  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns a not found message' do
  #       expect(response.body).to match(/Couldn't find Region/)
  #     end
  #   end
  # end

  # # Test suite for DELETE /plans/:id
  # describe 'DELETE /plans/:id' do
  #   before { delete "/plans/#{plan_id}/plan_option/#{id}" }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end
