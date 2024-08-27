require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create!(user_name: "testuser", password: "password", password_confirmation: "password", display_name: "Test User") }

  describe 'POST #create' do

    context 'with invalid credentials' do
      it 'does not set the session[:user_id] and redirects to new_session_path' do
        post :create, params: { user_name: "testuser", password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(flash[:alert]).to eq("Invalid username or password")
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'DELETE #logout' do
    before do
      session[:user_id] = user.id
    end

    it 'resets the session and redirects to new_session_path' do
      delete :logout
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(new_session_path)
    end
  end
end
