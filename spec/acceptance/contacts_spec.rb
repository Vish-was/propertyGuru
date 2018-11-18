require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Contacts" do
  header "Accept", "application/json"
  
  let!(:builder) { create(:builder) }
  let!(:region) { create(:region, builder_id: builder.id) }
  let!(:division) { create(:division, region_id: region.id) }
  let!(:contacts) { create_list(:contact, 25, division_id: division.id) }

  let!(:contact_to_test) { contacts.sample }
  let!(:division_id) { division.id }
  let!(:id) { contact_to_test.id }
  let!(:user) { create(:user) }
  let(:builder_id) { builder.id }

  let(:page_size) { Faker::Number.between(1, contacts.size) }
  let(:page_number) { Faker::Number.between(1, 10) }

  get "/divisions/:division_id/contacts" do
    parameter :page, "Which page of results (default 1)"
    parameter :per_page, "How many results per page (default 20)"

    example "List all contacts" do
      do_request

      result_compare_with_db(json, Contact)
      expect(status).to eq(200)
    end

    example "Get all contacts, limited by page size" do
      do_request(per_page: page_size)

      result_compare_with_db(json, Contact)
      expect(response_size).to eq(paged_size(contacts, page_size))
      expect(json['total_count']).to eq(contacts.size)

      expect(status).to eq(200)
    end

    example_request "Get all contacts, with paging" do
      do_request(per_page: page_size, page: 2)

      result_compare_with_db(json, Contact)
      expect(response_size).to eq(paged_size(contacts, page_size, 2))
      expect(status).to eq(200)
    end

    example_request "Get all contacts, with random page" do
      do_request(per_page: page_size, page: page_number)

      result_compare_with_db(json, Contact)
      expect(response_size).to eq(paged_size(contacts, page_size, page_number))
      expect(status).to eq(200)
    end
  end

  get "/contacts/:id" do
    example_request "Get a specific contact" do
      expect(status).to eq(200)
    end
  end

  post "/builders/:builder_id/contacts" do
    before(:each) do
      check_login(user)
    end
    parameter :name, required: true
    parameter :phone 
    parameter :email, required: true
    parameter :logo
    parameter :title
    
    example_request "Create a new Contact" do
      name = Faker::Name.name 
      phone =  Faker::PhoneNumber.phone_number 
      email = Faker::Internet.email 
      title = Faker::Job.title 

      do_request( name: name, phone: phone, email: email, title: title)

      expect(json['name']).to eq(name)
      expect(json['email']).to eq(email)
      expect(status).to eq(201)
    end
  end
  
  put "/contacts/:id" do
    before(:each) do
      check_login(user)
    end
    parameter :name, required: true
    parameter :phone 
    parameter :email, required: true
    parameter :logo
    parameter :title
    

    example_request "Rename a Builder" do
      name = Faker::Name.name 
      phone =  Faker::PhoneNumber.phone_number 
      email = Faker::Internet.email 
      title = Faker::Job.title 
      do_request(name: name)

      contact = Contact.find(id)
      expect(contact.name).to eq(name)
      expect(status).to eq(200)

    end
  end

  delete "/contacts/:id" do
    before(:each) do
      check_login(user)
    end
    example_request "Delete a contact" do
      contact_id = create(:contact, name: "Delete me", builder_id: builder.id).id

      do_request(id: contact_id)

      expect(Contact.where(id: contact_id).size).to be(0)
      expect(status).to eq(204)
    end
  end

end
