require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "CommunityGallery" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:communities) { create_list(:community, 25, division_id: division.id) }
  let!(:community_to_test) { communities.sample }
  let!(:user) { create(:user) }

  delete "community_gallery/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a plan_gallery" do
      community_gallery_id = create(:community_gallery, community_id: community_to_test.id).id
      do_request(id: community_gallery_id)
      expect(CommunityGallery.where(id: community_gallery_id).size).to be(0)
      expect(status).to eq(204)
    end
  end
end   

