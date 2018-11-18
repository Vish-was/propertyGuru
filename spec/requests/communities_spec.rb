require 'rails_helper'

RSpec.describe 'Communities API', type: :request do
  # Initialize the test data
  let!(:builder) {create (:builder)}
  let!(:region) { create(:region, builder_id: builder.id)}
  let!(:division) { create(:division, region_id: region.id) }
  let!(:division_id) { division.id }
  let!(:amenity) { create(:amenity) }
  let!(:communities) { create_list(:community, 25, division_id: division.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id ) }  
  let!(:plan_option) { create(:plan_option, plan_option_set_id: plan_option_set.id)}
  let(:user) {create(:user)}
  let!(:communities_plan) {create(:communities_plan, plan_id: plan.id, community_id: community_to_test.id)}
  let(:plan_id) { plan.id }
  let!(:community_to_test) { communities.sample }
  let!(:id) { community_to_test.id }
  let!(:valid_attributes) {{
    name:  Faker::Space.galaxy,
    location:  Faker::TwinPeaks.location,
    yearly_hoa_fees: Faker::Number.decimal(6,2),
    property_tax_rate: Faker::Number.decimal(6,2),
    division_id: division.id
  }}
  # Get /divisions/:division_id/communities
  describe '/divisions/:division_id/communities' do
    before { 
      @division = division
      get "/divisions/#{@division.id}/communities", as: :json
    }

    context 'when division exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all communities' do
        expect(json["results"].size).to eq(20)
      end
    end
  end

  # Get /communities/:id
  describe 'GET /communities/:id' do

    before { get "/communities/#{id}", as: :json }

    context 'when community exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when community does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Community/)
      end
    end
  end

  # POST /divisions/:division_id/communities
  describe 'POST /divisions/:division_id/communities' do
      context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { 
            @division = division
            post "/divisions/#{@division.id}/communities", 
                    params: valid_attributes
           }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the community name' do
            expect(Community.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end

        context 'and when request attributes are invalid' do
          before { 
            @division = division
            post "/divisions/#{@division.id}/communities", 
                   params: {} 
            }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\",\"Location can't be blank\"]}")
          end
        end
      end
      context 'when logged in user is builder' do
        before { 
          @user = user
          @user.add_role(:builder)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { 
            @division = division
            post "/divisions/#{@division.id}/communities", 
                    params: valid_attributes
             }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the community name' do
            expect(Community.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end

        context 'and when request attributes are invalid' do
          before { 
            @division = division
            post "/divisions/#{@division.id}/communities", 
                   params: {} 
            }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\",\"Location can't be blank\"]}")
          end
        end
      end
  end


 # Update PUT /communities/:id
   describe 'PUT /communities/:id' do
    context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
    sign_in :user
     
     context 'when community exists' do
        before { 
          @community = community_to_test
          put "/communities/#{@community.id}", 
               params: valid_attributes 
        }
       it 'returns status code 204' do
         expect(response).to have_http_status(204)
       end

       # it 'updates the community name' do
       #   expect(@community.name).to eq(valid_attributes[:name])
       # end
     end
     let(:valid_attribute) { { name: '' } }
     context 'when an invalid request' do
       before { 
          @community = community_to_test
          put "/communities/#{@community.id}", 
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
     
     context 'when community exists' do
        before { 
          @community = community_to_test
          put "/communities/#{@community.id}", 
               params: valid_attributes 
        }
       it 'returns status code 204' do
         expect(response).to have_http_status(204)
       end

       # it 'updates the community name' do
       #   expect(@community.name).to eq(valid_attributes[:name])
       # end
     end
    end
   end



  # DELETE /communities/:id
  describe 'DELETE /communities/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when community exists' do
        before {
          @community = community_to_test
          delete "/communities/#{@community.id}"
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
      context 'and when community exists' do
        before {
          @community = community_to_test
          delete "/communities/#{@community.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end

  # Get /communities/:id
  describe 'GET /communities/:id' do

    before { get "/communities/#{id}", as: :json }

    context 'when community exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when community does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Community/)
      end
    end
  end

  # POST /divisions/:division_id/communities
  describe 'POST /divisions/:division_id/communities' do
      context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/divisions/#{division_id}/communities", 
                    params: valid_attributes }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the community name' do
            expect(Community.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end

        context 'and when request attributes are invalid' do
          before { post "/divisions/#{division_id}/communities", 
                   params: {} }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\",\"Location can't be blank\"]}")
          end
        end
      end
      context 'when logged in user is builder' do
        before { 
          @user = user
          @user.add_role(:builder)
        }
        sign_in :user

        context 'and when request attributes are valid' do
          before { post "/divisions/#{division_id}/communities", 
                    params: valid_attributes }
          

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          it 'returns the new id' do
            expect(json['id']).to be > 0
          end

          it 'sets the community name' do
            expect(Community.find(json['id']).name).to eq(valid_attributes[:name])
          end
        end

        context 'and when request attributes are invalid' do
          before { post "/divisions/#{division_id}/communities", 
                   params: {} }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a failure message' do
            expect(response.body).to match("{\"errors\":[\"Name can't be blank\",\"Location can't be blank\"]}")
          end
        end
      end
  end


 # Update PUT /communities/:id
   describe 'PUT /communities/:id' do
    context 'when logged in user is admin' do
        before { 
          @user = user
          @user.add_role(:admin)
        }
    sign_in :user
     
     context 'when community exists' do
        before { 
          @community = community_to_test
          put "/communities/#{@community.id}", 
               params: valid_attributes 
        }
       it 'returns status code 204' do
         expect(response).to have_http_status(204)
       end

       # it 'updates the community name' do
       #   expect(@community.name).to eq(valid_attributes[:name])
       # end
     end
    end
    context 'when logged in user is builder' do
        before { 
          @user = user
          @user.add_role(:builder)
        }
    sign_in :user
     
     context 'when community exists' do
        before { 
          @community = community_to_test
          put "/communities/#{@community.id}", 
               params: valid_attributes 
        }
       it 'returns status code 204' do
         expect(response).to have_http_status(204)
       end

       # it 'updates the community name' do
       #   expect(@community.name).to eq(valid_attributes[:name])
       # end
     end
    end
   end



  # DELETE /communities/:id
  describe 'DELETE /communities/:id' do
    context 'when logged in user is admin' do
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when community exists' do
        before {
          @community = community_to_test
          delete "/communities/#{@community.id}"
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
      context 'and when community exists' do
        before {
          @community = community_to_test
          delete "/communities/#{@community.id}"
        }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end

  #GET /communities/x/plans
  describe 'get /communities/:id/plans' do
    before { get "/communities/#{id}/plans", as: :json }

    context 'when community exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all plans' do
        expect(json["results"].size).to eq(1)
      end
    end

    context 'when community does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Community/)
      end
    end
  end

  #POST /communities/x/plans/y
  describe 'post /communities/:id/plans/:plan_id' do
    let(:valid_param) {{
      :communities_plans => {
        :plan_id => plan.id,
        :community_id => community_to_test.id,
        base_price:  Faker::Number.decimal(5, 2) 

      }
    }}
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { post "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @plan = plan
               @community = community_to_test

               post "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }

            it 'returns already added message' do
               expect(response.body).to match(/Plan is already added to community/)
            end
          end
          context 'and plan is not added to community' do
            
            before {
               @plan = plan
               @community = community_to_test
               post "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            it 'should add plan to community' do
               expect(@community.reload.plans.length).to eq(1)
            end
            context 'and plan option exist for this plan' do
              before {
                 @plan = plan
                 @community = community_to_test
                 @plan_options = PlanOption.joins(:plan_option_set=>:plan).where('plans.id = ?', @plan.id)
              }
              it 'should create all plan options from community' do
                @plan_options.each do |plan_option|
                  @community.community_plan_options.create({:plan_option_id => plan_option.id, :base_price => plan_option.default_price})
                end
                expect(@community.reload.plan_options.length).to be > 0
              end
            end
          end
        end
      end
      context 'and when community does not exist' do       
        before {
          post "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { post "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @plan = plan
               @community = community_to_test
               post "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            it 'returns already added message' do
               expect(response.body).to match(/Plan is already added to community/)
            end
          end
          context 'and plan is not already added to community' do
            
            before {
               @plan = plan
               @community = community_to_test
               post "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            it 'should add plan to community' do
               expect(@community.reload.plans.length).to eq(1)
            end
 
            # it 'returns added message' do
            #    expect(response.body).to match(/Plan is added to community successfully/)
            # end
          end
        end
      end
      context 'and when community does not exist' do       
        before {
          post "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      before { 
        @user = user
        post "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param
      }
      sign_in :user

      it 'returns status code 403' do
         expect(response).to have_http_status(403)
      end
    end

    context 'when user is not logged in' do
 
      before { post "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
       
      it 'returns status code 401' do
         expect(response).to have_http_status(401)
      end
    end
  end

#put communities/x/plans/y
  describe 'put /communities/:id/plans/:plan_id' do
    let(:valid_param) {{
        :plan_id => plan.id,
        base_price:  Faker::Number.decimal(5, 2) 
    }}
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { put "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @community = community_to_test
               @plan = plan

               put "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }

            it 'should update plan from community' do
              @community.communities_plans.where("plan_id = ?", @plan.id).update(valid_param)
            end
          end
          context 'and plan is not already added to community' do
            
            before {
               @community = community_to_test
               @plan = plan
               put "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            
            # it 'returns not found message' do
            #    expect(response.body).to match(/Plan is not added to community/)
            # end
            # it 'returns added message' do
            #    expect(response.body).to match(/Plan is added to community successfully/)
            # end
          end
        end
      end
      context 'and when community does not exist' do       
        before {
          put "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { put "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @community = community_to_test
               @plan = plan

               put "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }

            it 'should update plan from community' do
              @community.communities_plans.where("plan_id = ?", @plan.id).update(valid_param)
            end
          end
          context 'and plan is not already added to community' do
            
            before {
               @community = community_to_test
               @plan = plan
               put "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            
            # it 'returns not found message' do
            #    expect(response.body).to match(/Plan is not added to community/)
            # end
            # it 'returns added message' do
            #    expect(response.body).to match(/Plan is added to community successfully/)
            # end
          end
        end
      end
      context 'and when community does not exist' do       
        before {
          put "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      before { 
        @user = user
        put "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param
      }
      sign_in :user

      it 'returns status code 403' do
         expect(response).to have_http_status(403)
      end
    end

    context 'when user is not logged in' do
 
      before { put "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param }
       
      it 'returns status code 401' do
         expect(response).to have_http_status(401)
      end
    end
  end

  #DELETE /communities/x/plans/y
  describe 'delete /communities/:id/plans/:plan_id' do
    let(:valid_param) {{
      :communities_plans => {
        :plan_id => plan.id,
        :community_id => community_to_test.id,
        base_price:  Faker::Number.decimal(5, 2) 

      }
    }}
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { delete "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @plan = plan
               @community = community_to_test

               delete "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
            
            it 'should remove plan from community' do
              @community.plans.destroy(@plan)
              expect(@community.reload.plans.length).to eq(0)
            end
            
            it 'returns removed message' do
               expect(response.body).to match(/Plan is removed from community/)
            end

            context 'and plan option exist for this plan' do
              before {
                 @plan = plan
                 @community = community_to_test
                 @plan_options = PlanOption.joins(:plan_option_set=>:plan).where('plans.id = ?', @plan.id)
              }
              it 'should remove all plan options from community' do
                @plan_options.each do |plan_option|
                  @community.community_plan_options.where("community_plan_options.plan_option_id = ? ", plan_option).destroy_all
                end
                expect(@community.reload.plan_options.length).to eq(0)
              end
            end
          end
          # context 'and plan is not added to community' do
            
          #   before {
          #      @plan = plan
          #      @community = community_to_test
          #      delete "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
          #   }
     
          #   it 'returns not found message' do
          #     expect(response.body).to match(/Plan is not added to community/)
          #   end
          # end
        end
      end
      context 'and when community does not exist' do       
        before {
          delete "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user 
      context 'and when community exists' do  
        context 'and plan does not exist' do
          
           before { delete "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
 
           let(:plan_id) { 0 }
 
           it 'returns status code 404' do
             expect(response).to have_http_status(404)
           end
 
           it 'returns a not found message' do
             expect(response.body).to match(/Couldn't find Plan/)
           end
        end
        context 'and plan exist' do
 
          context 'and plan is already added to community' do
 
            before {
               @plan = plan
               @community = community_to_test

               delete "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
            
            it 'should remove plan from community' do
              @community.plans.destroy(@plan)
              expect(@community.reload.plans.length).to eq(0)
            end
            
            it 'returns removed message' do
               expect(response.body).to match(/Plan is removed from community/)
            end

            context 'and plan option exist for this plan' do
              before {
                 @plan = plan
                 @community = community_to_test
                 @plan_options = PlanOption.joins(:plan_option_set=>:plan).where('plans.id = ?', @plan.id)
              }
              it 'should remove all plan options from community' do
                @plan_options.each do |plan_option|
                  @community.community_plan_options.where("community_plan_options.plan_option_id = ? ", plan_option).destroy_all
                end
                expect(@community.reload.plan_options.length).to eq(0)
              end
            end
          end
          context 'and plan is not added to community' do
            
            before {
               @plan = plan
               @community = community_to_test
               delete "/communities/#{@community.id}/plans/#{@plan.id}", as: :json, params: valid_param
            }
     
            # it 'returns not found message' do
            #   expect(response.body).to match(/Plan is not added to community/)
            # end
          end
        end
      end
      context 'and when community does not exist' do       
        before {
          delete "/communities/#{id}/plans/#{plan.id}", as: :json, params: valid_param
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      before { 
        @user = user
        delete "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param
      }
      sign_in :user

      it 'returns status code 403' do
         expect(response).to have_http_status(403)
      end
    end

    context 'when user is not logged in' do
 
      before { delete "/communities/#{id}/plans/#{plan_id}", as: :json, params: valid_param }
       
      it 'returns status code 401' do
         expect(response).to have_http_status(401)
      end
    end
  end
  
  # Get all PlanStyles of plan_id 
  describe 'GET /communities/:id/amenities' do
    context 'when community exists' do
      before {
        @community = community_to_test
        @community.amenities << amenity
        get "/communities/#{@community.id}/amenities", as: :json
      }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all amenities' do
        expect(json["results"].size).to eq(1)
      end
    end

    context 'when community does not exist' do
      before {
        get "/communities/#{id}/amenities", as: :json
      }
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Community/)
      end
    end
  end

  # Post Create PlansPlanStyles by plan_id and plan_style_id 
  describe 'POST /communities/:id/amenities/:amenity_id' do
    context 'when logged in user is admin' do
     
      before { 
        @user = user
        @user.add_role(:admin)     
      }
      sign_in :user
      context 'and when community exists' do
        
        context 'and amenity does not exist' do
         
          before { post "/communities/#{id}/amenities/#{amenity_id}", as: :json }

          let(:amenity_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Amenity/)
          end
        end

        context 'and amenity exist' do

          context 'and amenity is already added to community' do

            before {
              @community = community_to_test
              @amenity = amenity
              @community.amenities << @amenity
              post "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Amenity is already added to community/)
            end
          end

          context 'and amenity is not already added to community' do
           
            before {
              @community = community_to_test
              @amenity = amenity
              post "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'should add amenity to community' do
              expect(@community.reload.amenities.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Amenity is added to community successfully/)
            end
          end
        end
      end

      context 'and when community does not exist' do
        
        before {
          post "/communities/#{id}/amenities/#{amenity.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is builder' do
     
      before { 
        @user = user
        @user.add_role(:builder)
      }
      sign_in :user
      context 'and when community exists' do
        
        context 'and amenity does not exist' do
         
          before { post "/communities/#{id}/amenities/#{amenity_id}", as: :json }

          let(:amenity_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Amenity/)
          end
        end

        context 'and amenity exists' do

          context 'and amenity is already added to community' do

            before {
              @community = community_to_test
              @amenity = amenity
              @community.amenities << @amenity
              post "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns already added message' do
              expect(response.body).to match(/Amenity is already added to community/)
            end
          end

          context 'and amenity is not already added to community' do
           
            before {
              @community = community_to_test
              @amenity = amenity
              post "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'should add amenity to community' do
              expect(@community.reload.amenities.length).to eq(1)
            end

            it 'returns added message' do
              expect(response.body).to match(/Amenity is added to community successfully/)
            end
          end
        end
      end

      context 'and when community does not exist' do
        
        before {
          post "/communities/#{id}/amenities/#{amenity.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      
      before { 
        @user = user
        # @user.add_role(:admin)
         post "/communities/#{id}/amenities/#{amenity.id}", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
         post "/communities/#{id}/amenities/#{amenity.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Delete CommunitiesAmenities by community_id and amenity_id 
  describe 'DELETE /communities/:id/amenities/:amenity_id' do
    
    context 'when logged in user is admin' do
      
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when community exists' do
        
        context 'and amenity does not exist' do
         
          before { delete "/communities/#{id}/amenities/#{amenity_id}", as: :json }

          let(:amenity_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Amenity/)
          end
        end

        context 'and amenity exist' do

          context 'and amenity is already added to community' do

            before {
              @community = community_to_test
              @amenity = amenity
              @community.amenities << @amenity
              delete "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/Amenity deleted from community successfully/)
            end

            it 'should remove amenity from community' do
              expect(@community.reload.amenities.length).to eq(0)
            end

          end

          context 'and amenity is not added to community' do
            
            before {
              @community = community_to_test
              @amenity = amenity
              delete "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns amenity not added to community message' do
              expect(response.body).to match(/Amenity does not exist in community/)
            end
          end
        end
      end

      context 'and when community does not exist' do
        
        before {
          delete "/communities/#{id}/amenities/#{amenity.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is builder' do
      
      before { 
        @user = user
        @user.add_role(:admin)
      }
      sign_in :user
      context 'and when community exists' do
        
        context 'and amenity does not exist' do
         
          before { delete "/communities/#{id}/amenities/#{amenity_id}", as: :json }

          let(:amenity_id) { 0 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Amenity/)
          end
        end

        context 'and amenity exist' do

          context 'and amenity is already added to community' do

            before {
              @community = community_to_test
              @amenity = amenity
              @community.amenities << @amenity
              delete "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns removed message' do
              expect(response.body).to match(/Amenity deleted from community successfully/)
            end

            it 'should remove amenity from community' do
              expect(@community.reload.amenities.length).to eq(0)
            end

          end

          context 'and amenity is not added to community' do
            
            before {
              @community = community_to_test
              @amenity = amenity
              delete "/communities/#{@community.id}/amenities/#{@amenity.id}", as: :json
            }
    
            it 'returns amenity not added to community message' do
              expect(response.body).to match(/Amenity does not exist in community/)
            end
          end
        end
      end

      context 'and when community does not exist' do
        
        before {
          delete "/communities/#{id}/amenities/#{amenity.id}", as: :json
        }

        let(:id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Community/)
        end
      end
    end
    context 'when logged in user is not admin or builder' do
      before { 
        @user = user
        # @user.add_role(:admin)   
        delete "/communities/#{id}/amenities/#{amenity.id}", as: :json
      }
      sign_in :user
      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when user is not logged in' do
      
      before { 
        delete "/communities/#{id}/amenities/#{amenity.id}", as: :json
      }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end

