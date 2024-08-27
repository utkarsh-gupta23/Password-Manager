require 'rails_helper'

RSpec.describe CredentialsController, type: :controller do
  let(:user) { User.create!(user_name: "testuser", password: "password", display_name: "Test User") }
  let(:credential) { Credential.create!(user: user, title: "Example Title", username: "example_user", password: "password123", website: "http://example.com") } # Assuming you have a credential factory

  before do
    allow(controller).to receive(:set_current_user).and_return(user)
    controller.instance_variable_set(:@current_user, user)
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'assigns @credentials' do
      credential
      get :index
      expect(assigns(:credentials)).to eq([credential])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested credential to @credential' do
      get :show, params: { id: credential.id }
      expect(assigns(:credential)).to eq(credential)
    end

    it 'renders the show template' do
      get :show, params: { id: credential.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Credential to @credential' do
      get :new
      expect(assigns(:credential)).to be_a_new(Credential)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested credential to @credential' do
      get :edit, params: { id: credential.id }
      expect(assigns(:credential)).to eq(credential)
    end
  end

  describe 'POST #create' do
  context 'with valid attributes' do
    it 'creates a new credential' do
      expect {
        post :create, params: { credential: { title: "New Credential", username: "new_user", password: "new_password", website: "http://newsite.com", user_id: user.id } }
      }.to change(Credential, :count).by(1)
    end

    it 'redirects to the new credential' do
      post :create, params: { credential: { title: "New Credential", username: "new_user", password: "new_password", website: "http://newsite.com", user_id: user.id } }
      expect(response).to redirect_to(Credential.last)
    end
  end

  context 'with invalid attributes' do
    it 'does not save the new credential' do
      expect {
        post :create, params: { credential: { title: nil, username: "new_user", password: "new_password", website: "http://newsite.com", user_id: user.id } }
      }.not_to change(Credential, :count)
    end

    it 're-renders the new template' do
      post :create, params: { credential: { title: nil, username: "new_user", password: "new_password", website: "http://newsite.com", user_id: user.id } }
      expect(response).to render_template(:new)
    end
  end
end


  describe 'PATCH/PUT #update' do
    context 'with valid attributes' do
      it 'updates the credential' do
        patch :update, params: { id: credential.id, credential: { title: 'New Title' } }
        credential.reload
        expect(credential.title).to eq('New Title')
      end

      it 'redirects to the updated credential' do
        patch :update, params: { id: credential.id, credential: { title: 'New Title' } }
        expect(response).to redirect_to(credential)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the credential' do
        patch :update, params: { id: credential.id, credential: { title: nil } }
        credential.reload
        expect(credential.title).to_not be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { id: credential.id, credential: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the credential' do
      credential
      expect {
        delete :destroy, params: { id: credential.id }
      }.to change(Credential, :count).by(-1)
    end

    it 'redirects to credentials#index' do
      delete :destroy, params: { id: credential.id }
      expect(response).to redirect_to(credentials_url)
    end
  end

  describe 'GET #search' do
    it 'assigns the searched credentials to @credentials' do
      get :search, params: { search: credential.title }
      expect(assigns(:credentials)).to eq([credential])
    end

    it 'renders the index template' do
      get :search, params: { search: credential.title }
      expect(response).to render_template(:index)
    end
  end
end
