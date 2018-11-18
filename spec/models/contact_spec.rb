require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should belong_to(:division) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }

  it { should_not validate_presence_of(:phone) }

  context "with new contact set as default" do
    let!(:builder) { create(:builder) }
    let!(:region) { create(:region, builder_id: builder.id) }
    let!(:division) { create(:division, region_id: region.id) }
    let!(:contact_old) { create(:contact, division_id: division.id, builder_default: true) }

    it "marks the old contact as not default" do
      expect(Contact.find(contact_old.id).builder_default).to be(true)
      contact_new = create(:contact, division_id: division.id, builder_default: true)
      expect(Contact.find(contact_new.id).builder_default).to be(true)
      expect(Contact.find(contact_old.id).builder_default).to be(false)
    end
  end
end
