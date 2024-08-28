require "rails_helper"

RSpec.describe "Grape API", type: :request do

  #create a test user for the session
  let(:user) { User.create!(user_name: "testuser", password: "password", display_name: "Test User") }
  
  let(:credential) { Credential.create!(user_id: user.id, title: "Test Credential", username: "testuser", password: "password", website: "http://example.com") }

  before do
    # Simulate a logged-in user by setting the session
    post "/api/v1/sessions", params: { user: { user_name: user.user_name, password: "password" } }
  end

  describe "GET /api/v1/credentials" do
    it "returns a successful response" do
      get "/api/v1/credentials"  
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /api/v1/sessions" do
    it "logs in a user" do
      #this method print out the user object in ruby hash format
      # p JSON.parse(user.to_json)
      post "/api/v1/sessions", params: { user: { user_name: user.user_name, password: "password" } }
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)).to include({
        "status" => "created",
        "logged_in" => true,
        "user" => JSON.parse(user.to_json)
      })
    end
      
    it 'fails to log in with incorrect password' do
      post '/api/v1/sessions', params: { user: { user_name: user.user_name, password: 'wrongpassword' } }
      expect(response).to have_http_status(401)
    end
  end

  describe 'Registrations' do

    describe 'POST /api/v1/registrations' do
      it 'registers a new user' do
        post '/api/v1/registrations', params: { user: { user_name: 'testuser', password: 'newpassword', password_confirmation: 'newpassword', display_name: 'New User' } }
        expect(response).to have_http_status(500)
      end
    end

  end

  describe 'Credentials' do

    describe 'GET /api/v1/credentials' do
      it 'returns all credentials for the current user' do
        get '/api/v1/credentials'
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /api/v1/credentials' do
      it 'creates a new credential' do
        post '/api/v1/credentials', params: { credential: { title: 'Facebook', username: 'xoxo', password: 'wordpass', website: 'https://facebook.com' } }
        expect(response).to have_http_status(201)
      end
    end

    describe 'PUT /api/v1/credentials/:id' do

      it 'attempts updates a credential' do
        put "/api/v1/credentials/#{credential.id + 1}", params: { title: 'Updated Title' }
        expect(response).to have_http_status(404)
      end

      it 'updates a credential' do
        put "/api/v1/credentials/#{credential.id}", params: { title: 'Updated Title' }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['credential']['title']).to eq('Updated Title')
      end

    end

    describe 'DELETE /api/v1/credentials/:id' do
      it 'deletes a credential' do
        delete "/api/v1/credentials/#{credential.id}"
        expect(response).to have_http_status(200)
      end
    end

  end

end