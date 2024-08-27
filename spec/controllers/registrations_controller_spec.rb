require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:user) { User.create!(user_name: "testuser", password: "password", password_confirmation: "password", display_name: "Test User") }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and redirects to the new session path' do
        expect {
          post :create, params: { user_name: "newuser", display_name: "New User", password: "newpassword", password_confirmation: "newpassword" }
        }.to change(User, :count).by(1)
        expect(session[:user_id]).to eq(User.last.id)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with invalid attributes' do
      it 'renders a JSON response with status 500' do
        expect {
          post :create, params: { user_name: "newuser", display_name: "New User", password: "newpassword", password_confirmation: "wrongconfirmation" }
        }.to_not change(User, :count)
        expect(response.body).to eq({ status: 500, error: "Validation failed: Password confirmation doesn't match Password" }.to_json)
      end
    end
  end

end
