# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contact API', type: :request do
  let!(:builder) { create(:builder) }
  let(:builder_id) { builder.id }
  let(:user) { create(:user) }
  let(:contact) { create(:contact, builder: builder) }
  let(:region) { create(:region, builder: builder) }
  let(:division) { create(:division, region: region) }

  let!(:valid_attributes) {{
    name:  Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    title: Faker::Job.title
  }}

  describe 'Create contacts under division' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'create contacts' do
        before do
          post "/divisions/#{division.id}/contacts", params: valid_attributes
        end

        it 'should save contacts' do
          expect(response).to have_http_status(201)
        end
      end
    end
  end

  describe 'Create contacts under builder' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'create contacts' do
        before do
          post "/builders/#{builder_id}/contacts", params: valid_attributes
        end

        it 'should save contacts' do
          expect(response).to have_http_status(201)
        end
      end
      context 'create contacts with empty email' do
        before do
          post "/builders/#{builder_id}/contacts", params: { name: 'Test', email: nil }
        end

        it 'should save contacts' do
          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['errors'].class).to eq(Array)
        end
      end
    end

    context 'when regular user log in' do
      before do
        @user = user
      end

      sign_in :user

      context 'create contacts' do
        before do
          post "/builders/#{builder_id}/contacts", params: valid_attributes
        end

        it 'should return forbidden' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe 'Updaing existing contacts' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'update contacts' do
        before do
          put "/contacts/#{contact.id}", params: { name: 'Test' }
        end

        it 'should save contacts' do
          expect(response).to have_http_status(200)
          contact.reload
          expect(contact.name).to eq('Test')
        end
      end

      context 'update contacts with empty email' do
        before do
          put "/contacts/#{contact.id}", params: { name: 'Test', email: nil }
        end

        it 'should save contacts' do
          expect(response).to have_http_status(422)
          contact.reload
          expect(json['errors'].class).to eq(Array)
        end
      end
    end
  end

  describe 'Delete existing contacts' do
    context 'when admin logged in' do
      before do
        @user = user
        @user.add_role(:admin)
      end

      sign_in :user

      context 'delete contacts' do
        before do
          delete "/contacts/#{contact.id}"
        end

        it 'should save contacts' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
