require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          name: 'Test User'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: '',
          password: '',
          name: ''
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post '/api/v1/users', params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns status 201' do
        post '/api/v1/users', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns JSON with user data' do
        post '/api/v1/users', params: valid_params
        
        json_response = JSON.parse(response.body)
        
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('User created successfully')
        expect(json_response['data']['user']['email']).to eq('test@example.com')
        expect(json_response['data']['user']['name']).to eq('Test User')
        expect(json_response['data']['user']['role']).to eq('user')
        expect(json_response['data']['user']).to have_key('id')
        expect(json_response['data']['user']).to have_key('created_at')
      end

      it 'sets provider and uid correctly' do
        post '/api/v1/users', params: valid_params
        
        user = User.last
        expect(user.provider).to eq('email')
        expect(user.uid).to eq('test@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'does not create user when email is missing' do
        expect {
          post '/api/v1/users', params: invalid_params
        }.not_to change(User, :count)
      end

      it 'returns status 422' do
        post '/api/v1/users', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/v1/users', params: invalid_params
        
        json_response = JSON.parse(response.body)
        
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Failed to create user')
        expect(json_response['errors']).to include("Email can't be blank")
        expect(json_response['errors']).to include("Name can't be blank")
      end
    end

    context 'when user already exists' do
      before do
        create(:user, email: 'test@example.com')
      end

      it 'does not create a duplicate user' do
        expect {
          post '/api/v1/users', params: valid_params
        }.not_to change(User, :count)
      end

      it 'returns status 422' do
        post '/api/v1/users', params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns correct error message' do
        post '/api/v1/users', params: valid_params
        
        json_response = JSON.parse(response.body)
        
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('User already exists')
        expect(json_response['errors']).to include('Email is already taken')
      end
    end
  end
end
