require 'rails_helper'

RSpec.describe 'PlanStyles API', type: :request do
  # initialize test data 
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:plan_styles) { create_list(:plan_style, 10) }
  let!(:plan_style_to_test) { plan_styles.sample }
  let(:id) { plan_style_to_test.sample.id }
  
  # Get all Plans of plan_style_id 
  describe 'GET /plan_styles/:id/plans' do
    context 'when plan_style exists' do
        before {
          @plan_style = plan_style_to_test
          @plan_style.plans << plan
          get "/plan_styles/#{@plan_style.id}/plans", as: :json
        }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all plans' do
          expect(json["total_count"]).to eq(1)
        end
    end

    context 'when plan_style does not exist' do
      before {
        get "/plan_styles/#{id}/plans", as: :json
      }

      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find PlanStyle/)
      end
    end
  end
end