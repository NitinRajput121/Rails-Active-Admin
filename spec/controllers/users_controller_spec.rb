

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    { user: { name: 'John Doe', email: 'unique_email@example.com', password: 'password123', user_type: 'customer' } }
  end

  let(:invalid_attributes) do
    { user: { name: '', email: 'unique_email@example.com', password: '', user_type: 'customer' } }
  end

  let!(:existing_user) { create(:user, email: 'existing_user@example.com', password: 'password123') }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post :create, params: valid_attributes
          puts response.body
        }.to change(User, :count).by(1)
      end

      it 'renders a success message' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('User created')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post :create, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it 'renders error messages' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Password can't be blank")
      end
    end

    context 'when email is already taken' do
      it 'does not create a new user' do
        post :create, params: { user: { name: 'Duplicate', email: 'existing_user@example.com', password: 'password123', user_type: 'customer' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Email has already been taken')
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'authenticates the user and returns a token' do
        post :login, params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
        expect(JSON.parse(response.body)['message']).to eq('Login successful')
      end
    end

    context 'with invalid credentials' do
      it 'does not authenticate the user' do
        post :login, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user, email: 'user_to_update@example.com', password: 'password123') }

    context 'with valid parameters' do
      it 'updates the user' do
        patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
        user.reload
        expect(user.name).to eq('Updated Name')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('User updated')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, user: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:user) { create(:user, email: 'user_to_delete@example.com', password: 'password123') }

    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('User deleted')
    end

    it 'returns an error if the user does not exist' do
      delete :destroy, params: { id: 999 } # Non-existing ID
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('User not found')
    end
  end
end
