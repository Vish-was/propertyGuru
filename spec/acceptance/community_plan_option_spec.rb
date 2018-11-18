require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "CommunityPlanOptions" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:community) {create(:community, region_id: region.id)}
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan_style) { create(:plan_style) }
  let!(:plan) {create(:plan, collection_id: collection.id, plan_style_id: plan_style.id)}
  let!(:plan_option) {create(:plan_option, plan_id: plan.id)}
  let!(:community_plan_option) { create_list(:community_plan_option, 25, community_id: community.id, plan_option_id: plan_option.id) }
  let!(:collection_to_test) { community_plan_option.sample }
  let(:id) {collection_to_test.id}

end