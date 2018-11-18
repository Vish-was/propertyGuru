require 'rails_helper'

RSpec.describe 'Plans API', type: :request do
  # Initialize the test data
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let(:collection_id) { collection.id }
  let!(:plan_style) { create(:plan_style) }

  let!(:division) { create(:division, region_id: region.id) } 
  let!(:community) { create(:community, division_id: division.id) }
  let(:community_id) { community.id}
  let!(:lot) { create(:lot, community_id: community.id)}
  let(:lot_id) { lot.id}
  let!(:plans) { create_list(:plan, 25, collection_id: collection.id) }
  let!(:plan_to_test) { plans.sample }
  let!(:communities_plan) { create(:communities_plan, community_id: community.id, plan_id: plan_to_test.id) }
  let!(:id) { plan_to_test.id }
  let!(:user) { create(:user) }
  let!(:user_viewed_plan) { create(:user_viewed_plan, user_id: user.id, plan_id: plan_to_test.id) }

  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
    information:  Faker::Lorem.paragraphs,
    min_price:  Faker::Number.decimal(6,0),
    min_sqft:  Faker::Number.between(400,20000),
    min_bedrooms:  (Faker::Number.between(2,14))/2,
    min_bathrooms:  (Faker::Number.between(1,10))/2,
    min_garage: (Faker::Number.between(2,10))/2,
    max_price:  Faker::Number.decimal(6,0),
    max_sqft:  Faker::Number.between(400,20000),
    max_bedrooms:  (Faker::Number.between(2,14))/2,
    max_bathrooms:  (Faker::Number.between(1,10))/2,
    max_garage: (Faker::Number.between(2,10))/2,
    min_stories: Faker::Number.between(1,4),
    max_stories: Faker::Number.between(4,8),
    image:  fixture_file_upload("#{Rails.root}/public/missing_images/elevations.png", 'image/png'),
    collection_id: collection.id
  }}

  
  # Get all plans
  describe '/plans' do
    let(:value) { Faker::Number.between(2,14) }
    let(:order) { 'DESC' }
    let(:select_result) { double('select') }
    let(:joins_result) { double('joins') }
    let(:group_result) { double('group') }
    let(:trainees_list) { [] }
    context 'when popular_top parameter exists' do
      context 'and when plan is group by id' do
        context 'and when plan is order by count in descending order' do
          before { get "/plans?popular_top=#{value}", as: :json }
          
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'returns all plans from UserViewedPlans' do
          allow(Plan).to receive(:joins).with(:user_viewed_plans).and_return(joins_result)
          allow(joins_result).to receive(:select)
                .with("count(*) as plan_view_count, plans.*"
                ).and_return(select_result)
          allow(select_result).to receive(:group).with('plans.id').and_return(group_result)
          allow(group_result).to receive(:order).with(plan_view_count: order).and_return(trainees_list)
            expect(json["results"].size).to be > 0
          end
        end
      end
    end
    context 'when popular_top parameter does not exists' do
      before { get "/plans", as: :json }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      # it 'returns all plans with community base prices object' do
      #   expect(json["results"].size).to eq(20)
      #   expect(json['results'][0]['community_base_prices'][0]['base_price'].to_d).to eq(communities_plan.base_price)
      #   expect(json['results'][0]['community_base_prices'][0]['name']).to eq(communities_plan.community.name)
      # end
    end
  end

  # Get a single plan
  describe 'GET /plans/:id' do

    let!(:elevations) { create_list(:elevation, 4, plan: plan_to_test) }
    let!(:plan_image1) { create(:plan_image, story: 1, plan: plan_to_test) }
    let!(:plan_image2) { create(:plan_image, story: 2, plan: plan_to_test) }
    let!(:plan_images) { create_list(:plan_image, 3, plan: plan_to_test) }
    
    before { get "/plans/#{id}", as: :json }

    context 'when plan exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end
  # GET plans/:id/vr
  describe 'GET /plans/:id/vr' do

    let!(:elevations) { create_list(:elevation, 4, plan: plan_to_test) }
    let!(:plan_option_set1) { create(:plan_option_set, plan: plan_to_test) }
    let!(:plan_option_set2) { create(:plan_option_set,  plan: plan_to_test) }
    let!(:plan_option_sets) { create_list(:plan_option_set, 20, plan: plan_to_test) }
    let!(:plan_option1) { create(:plan_option, plan_option_set: plan_option_set1) }
    let!(:plan_option2) { create(:plan_option, plan_option_set: plan_option_set2) }
    let!(:plan_options) { create_list(:plan_option, 20, plan_option_set: plan_option_set1) }
    let!(:plan_image1) { create(:plan_image, story: 1, plan: plan_to_test) }
    let!(:plan_image2) { create(:plan_image, story: 2, plan: plan_to_test) }
    let!(:plan_images) { create_list(:plan_image, 3, plan: plan_to_test) }
    
    before { get "/plans/#{id}/vr", as: :json }

    context 'when plan exists' do
      context 'and get vr_scene from plan' do
        context 'and get vr_hotspot from vr_scene' do
          context 'and get plan_option_set from vr_hotspot' do
            context 'and get plan_option from plan_option_set' do
              it 'returns status code 200' do
                expect(response).to have_http_status(200)
              end
            end
          end
        end
      end
    end
  end

  #GET /plans/x/communities
  describe 'get /plans/:id/communities' do
    context 'when plan exists' do
      before { 
        @plan = plan_to_test
        get "/plans/#{@plan.id}/communities", as: :json
      }
      it 'returns status code 200' do
          expect(response).to have_http_status(200)
      end
    end

    context 'when plan does not exist' do

      before { get "/plans/#{id}/communities", as: :json }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end

  # POST /collections/:collection_id/plans
  describe '# POST /collections/:collection_id/plans' do 
   context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'when the request is valid' do
        before { post "/collections/#{collection_id}/plans", params: valid_attributes }
        it 'returns status code 201' do        
          expect(response).to have_http_status(201)
        end
      end
      context 'when the request is invalid' do
        before { post "/collections/#{collection_id}/plans", params: { } }

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
      context 'when the request is valid' do
        before { post "/collections/#{collection_id}/plans", params: valid_attributes }
        it 'returns status code 201' do        
          expect(response).to have_http_status(201)
        end
      end
      context 'when the request is invalid' do
        before { post "/collections/#{collection_id}/plans", params: { } }

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
  # Test suite for PUT /lots/:id
  describe 'PUT /plans/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }

      sign_in :user
      let(:valid_attributes) { { name: 'Body' } }

      context 'when the record exists' do
        before { put "/plans/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      context 'when an invalid request' do
        before { put "/plans/#{id}", params: {name: ""} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
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
        before { put "/plans/#{id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
      context 'when an invalid request' do
        before { put "/plans/#{id}", params: {name: ""} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
  # Test suite for DELETE /plans/:id
  describe 'DELETE /plans/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin) 
      }
      sign_in :user
      context 'and a valid request' do
        before { delete "/plans/#{plan_to_test.id}" }

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
      context 'and a valid request' do
        before { delete "/plans/#{plan_to_test.id}" }

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end

  # Get all Lots of plan_id 
  describe 'GET /plans/:id/lots' do
    context 'when plan exists' do
      before {
        @plan = plan_to_test
        @plan.lots << lot
        get "/plans/#{@plan.id}/lots", as: :json
      }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all lots' do
        expect(json["results"].size).to eq(1)
      end
    end
    context 'when plan does not exist' do
      before {
        get "/plans/#{id}/lots", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end


  # Get all PlanStyles of plan_id 
  describe 'GET /plans/:id/plan_styles' do
    context 'when plan exists' do
      before {
        @plan = plan_to_test
        @plan.plan_styles << plan_style
        get "/plans/#{@plan.id}/plan_styles", as: :json
      }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all plan_styles' do
        expect(json["results"].size).to eq(1)
      end
    end

    context 'when plan does not exist' do
      before {
        get "/plans/#{id}/plan_styles", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end

  # Post Create PlansPlanStyles by plan_id and plan_style_id 
  describe 'POST /plans/:id/plan_styles/:plan_style_id' do
    
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when plan exists' do
        context 'and plan_style does not exist' do
         
          before { post "/plans/#{id}/plan_styles/#{plan_style_id}", as: :json}

          let(:plan_style_id) { 0 }
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find PlanStyle/)
          end
        end

        context 'and plan_style exist' do

          context 'and plan style is already added to plan' do

            before {
              @plan = plan_to_test
              @plan_style = plan_style
              @plan.plan_styles << @plan_style
              post "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Plan style already added to plan/)
            end
          end

          context 'and plan style is not already added to plan' do
           
            before {
              @plan = plan_to_test
              @plan_style = plan_style
              post "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'should add plan_style to plan' do
              expect(@plan.reload.plan_styles.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Plan style added to plan successfully/)
            end
          end
        end
      end

      context 'and when plan does not exist' do
        
        before {
          post "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
        # @user.add_role(:admin)
        auth_headers = @user.create_new_auth_token

         post "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json, headers: auth_headers
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before {
        post "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

    # Delete PlansPlanStyles by plan_id and plan_style_id 
  describe 'DELETE /plans/:id/plan_styles/:plan_style_id' do
    
    context 'when logged in user is admin' do

      before { 
        @user = user
        @user.add_role(:admin)

      }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and plan_style does not exist' do
         
          before { delete "/plans/#{id}/plan_styles/#{plan_style_id}", as: :json }

          let(:plan_style_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find PlanStyle/)
          end
        end

        context 'and plan_style exist' do

          context 'and plan style is already added to plan' do

            before {
              @plan = plan_to_test
              @plan_style = plan_style
              @plan.plan_styles << @plan_style
              delete "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/Plan style deleted from plan successfully/)
            end

            it 'should remove plan_style from plan' do
              expect(@plan.reload.plan_styles.length).to eq(0)
            end
          end
          context 'and plan style is not added to plan' do
            
            before {
              @plan = plan_to_test
              @plan_style = plan_style
              delete "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'returns plan style not added to plan message' do
              expect(response.body).to match(/Plan style does not exist in plan/)
            end
          end
        end
      end
      context 'and when plan does not exist' do
        
        before {
          delete "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end


        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is builder' do

      before { 
        @user = user
        @user.add_role(:builder)
        }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and plan_style does not exist' do
         
          before { delete "/plans/#{id}/plan_styles/#{plan_style_id}", as: :json }

          let(:plan_style_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find PlanStyle/)
          end
        end

        context 'and plan_style exist' do

          context 'and plan style is already added to plan' do

            before {
              @plan = plan_to_test
              @plan_style = plan_style
              @plan.plan_styles << @plan_style
              delete "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/Plan style deleted from plan successfully/)
            end
            it 'should remove plan_style from plan' do
              expect(@plan.reload.plan_styles.length).to eq(0)
            end
          end
          context 'and plan style is not added to plan' do
            
            before {
              @plan = plan_to_test
              @plan_style = plan_style
              delete "/plans/#{@plan.id}/plan_styles/#{@plan_style.id}", as: :json
            }
    
            it 'returns plan style not added to plan message' do
              expect(response.body).to match(/Plan style does not exist in plan/)
            end
          end
        end
      end
      context 'and when plan does not exist' do
        
        before {
          delete "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
        }
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
        # @user.add_role(:admin)
        
        
        delete "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
        delete "/plans/#{id}/plan_styles/#{plan_style.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Delete PlansPlanStyles by plan_id and plan_style_id 
  describe 'DELETE /plans/:id/lots/:lot_id' do
    
    context 'when logged in user is admin' do
      
      before { 
        @user = user
        @user.add_role(:admin)

                }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and lot does not exist' do
         
          before { delete "/plans/#{id}/lots/#{lot_id}", as: :json }

          let(:lot_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Lot/)
          end
        end

        context 'and lot exist' do

          context 'and lot is already added to plan' do

            before {
              @plan = plan_to_test
              @lot = lot
              @plan.lots << @lot
              delete "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/Lot deleted from plan successfully/)
            end

            it 'should remove lot from plan' do
              expect(@plan.reload.lots.length).to eq(0)
            end
          end

          context 'and lot is not added to plan' do
            
            before {
              @plan = plan_to_test
              @lot = lot
              delete "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'returns lot not added to plan message' do
              expect(response.body).to match(/Lot does not exist in plan/)
            end
           end
         end
       end

      context 'and when plan does not exist' do
        
        before {
          delete "/plans/#{id}/lots/#{lot.id}", as: :json
        }
        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:builder)

      }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and lot does not exist' do
         
          before { post "/plans/#{id}/lots/#{lot_id}", as: :json }

          let(:lot_id) { 0 }
 
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Lot/)
          end
        end

        context 'and lot exist' do

          context 'and lot is already added to plan' do

            before {
              @plan = plan_to_test
              @lot = lot
              @plan.lots << @lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Lot is already added to plan/)
            end
          end

          context 'and lot is not already added to plan' do
           
            before {
              @plan = plan_to_test
              @lot = lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'should add lot to plan' do
              expect(@plan.reload.lots.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Lot is added to plan successfully/)
            end
          end
        end
      end
      context 'and when plan does not exist' do
        
        before {
          post "/plans/#{id}/lots/#{lot.id}", as: :json
        }

        let(:id) { 0 }
 
        it 'returns status code 404' do
           expect(response).to have_http_status(404)
        end
 
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
        post "/plans/#{id}/lots/#{lot.id}", as: :json
      }
      sign_in :user

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
        post "/plans/#{id}/lots/#{lot.id}", as: :json 
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

# Post Create PlansLots by plan_id and lot_id 
  describe 'POST /plans/:id/lots/:lot_id' do
    
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and lot does not exist' do
         
          before { post "/plans/#{id}/lots/#{lot_id}", as: :json }

          let(:lot_id) { 0 }
 
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Lot/)
          end
        end

        context 'and lot exist' do

          context 'and lot is already added to plan' do

            before {
              @plan = plan_to_test
              @lot = lot
              @plan.lots << @lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Lot is already added to plan/)
            end
          end

          context 'and lot is not already added to plan' do
           
            before {
              @plan = plan_to_test
              @lot = lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'should add lot to plan' do
              expect(@plan.reload.lots.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Lot is added to plan successfully/)
            end
          end
        end
      end

      context 'and when plan does not exist' do
        
        before {
          post "/plans/#{id}/lots/#{lot.id}", as: :json
        }

        let(:id) { 0 }
 
        it 'returns status code 404' do
           expect(response).to have_http_status(404)
        end
 
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:builder)

      }
      sign_in :user
      context 'and when plan exists' do
        
        context 'and lot does not exist' do
         
          before { post "/plans/#{id}/lots/#{lot_id}", as: :json }

          let(:lot_id) { 0 }
 
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Lot/)
          end
        end

        context 'and lot exist' do

          context 'and lot is already added to plan' do

            before {
              @plan = plan_to_test
              @lot = lot
              @plan.lots << @lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Lot is already added to plan/)
            end
          end

          context 'and lot is not already added to plan' do
           
            before {
              @plan = plan_to_test
              @lot = lot
              post "/plans/#{@plan.id}/lots/#{@lot.id}", as: :json
            }
    
            it 'should add lot to plan' do
              expect(@plan.reload.lots.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Lot is added to plan successfully/)
            end
          end
        end
      end
      context 'and when plan does not exist' do
        
        before {
          post "/plans/#{id}/lots/#{lot.id}", as: :json
        }

        let(:id) { 0 }
 
        it 'returns status code 404' do
           expect(response).to have_http_status(404)
        end
 
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Plan/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
        post "/plans/#{id}/lots/#{lot.id}", as: :json
      }
      sign_in :user

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
        post "/plans/#{id}/lots/#{lot.id}", as: :json 
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is not logged in' do
        
      before { 
        delete "/plans/#{id}/lots/#{lot.id}", as: :json
      }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end 
  end
  # Get all User Viewed Plans
  describe 'GET /plans/:id/viewed_users' do
    context 'when plan exists' do
      before {
        @plan = plan_to_test
        
        get "/plans/#{@plan.id}/viewed_users", as: :json
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all viewed_users' do
        expect(json.size).to be > 0
      end
    end
    context 'when plan does not exist' do
      before {
        get "/plans/#{id}/viewed_users", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end
end