require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Authorization" do
  parameter :auth_token, "Authentication Token"

  let!(:users) { create_list(:user, 30) }
  let!(:user_to_test) { users.sample }
  let!(:auth_token) { user_to_test.create_new_auth_token }
  let!(:id) { user_to_test.id }

  let!(:email) { Faker::Internet.email }
  let!(:password) { Faker::Internet.password }
  let!(:password_confirmation) { password }
  let!(:confirm_success_url) { Faker::Internet.url }


  def error_message
    json['errors']['full_messages']
  end

  post "/auth" do
    parameter :email, :required => true
    parameter :password, :required => true
    parameter :password_confirmation, :required => true
    parameter :confirm_success_url, "URL to redirect to after clicking the link in the confirmation email", :required => true
    parameter :name, "Full name of user"

    example "^^^See more details at https://github.com/lynndylanhurley/devise_token_auth#usage-tldr^^^" do
    end

    example "Sign up for new account" do
      do_request

      expect(status).to eq(200)
      expect(json['status']).to eq('success')
      expect(json['data']['id']).to be_present 
    end

    example "Sign up for account with bad email" do
      do_request(email: Faker::Lorem.word)

      expect(status).to eq(422)
      expect(error_message).to include('Email is not an email')
    end

    example "Sign up for account that already exists" do
      do_request
      do_request

      expect(status).to eq(422)
      expect(json['status']).to eq('error')
      expect(error_message).to include('Email has already been taken')
      expect(User.where(email: email).size).to eq(1) 
    end
  end

  put "/auth" do
    parameter :password
    parameter :password_confirmation
    parameter :name, "Full name of user"

    example "Update User Account Information" do
      do_request
    end
  end


  post "/auth/sign_in" do 
    parameter :email, :required => true
    parameter :password, :required => true

    example "User log in" do
      do_request(email: user_to_test.email, password: user_to_test.password)

      # expect(json['data'].to_json).to eq(user_to_test.to_json)
      expect(status).to eq(200)
    end
  end

  delete "/auth/sign_out" do 
    parameter :email, :required => true
    parameter :password, :required => true

    example "User log out" do
      do_request(email: user_to_test.email, password: user_to_test.password)
    end
  end

  get "/auth/validate_token" do

    example "Re-valiadate token on every client visit" do
      do_request
    end
  end

  post "/auth/password" do
    parameter :email, :required => true
    parameter :redirect_url, "URL to redirect to after clicking the link in the reset email"

    example "Send a password reset confirmation email (non-OAuth)" do
      do_request
    end
  end

  put "/auth/password" do
    parameter :password, :required => true
    parameter :password_confirmation, :required => true

    example "Change user password (non-OAuth)" do
      do_request
    end
  end

  get "/auth/password/edit" do
    parameter :reset_password_token, "Token sent in reset password email", :required => true
    parameter :redirect_url, "URL to redirect to after the user is verified", :required => true
  end

  get "/auth/google_oauth2" do
    example "Get login prompt for Google OAuth" do
      do_request
      expect(status).to eq(301)
    end
  end

  get "/auth/facebook" do
    example "Get login prompt for Facebook OAuth" do
      do_request
      expect(status).to eq(301)
    end
  end
end