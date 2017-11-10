# Authentication credential declared in spec/support/api_and_public_api.rb
# @staff_role
# @staff_user
# @staff_user_session

require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  let(:client2) { create :client }
  let!(:user2) { create :user, email: 'user2@aaa.aaa' }
  let!(:user3) { create :user, email: 'user3@aaa.aaa' }

  before(:each) do
    user2.roles << @staff_role
    user3.roles << @staff_role
  end

  let!(:session_data_admin) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @admin_user,
      '_t' => @admin_user_session.access_token
    }
  end

  let!(:session_data_user) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @staff_user,
      '_t' => @staff_user_session.access_token
    }
  end

  describe 'GET /users' do
    let!(:url) { '/api/v1/users' }

    context 'authenticated as admin' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('users')

        users = [@admin_user, @staff_user, @superadmin_user, user2, user3]
        expect(response.body).to match_json_payload(users_payload(users))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/users'
    end
  end

  describe 'GET /users/me' do
    let!(:url) { '/api/v1/users/me' }

    context 'authenticated' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('user')

        expect(response.body).to match_json_payload(user_payload(@admin_user))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/users'
    end
  end

  describe 'GET /users/:id' do
    let!(:url) { "/api/v1/users/#{@staff_user.id}" }
    context 'authenticated as customer' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('user')
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('user')
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/users/9999'
    end
  end

  describe 'POST /users' do
    let!(:url) { '/api/v1/users' }

    context 'authenticated as admin' do
      context 'with valid params' do
        let!(:valid_params) do
          { user: { email: 'aaa@bbb.ccc', password: 'password', password_confirmation: 'password' } }
        end

        before(:each) do
          post url, params: valid_params, headers: session_data_admin
        end

        it 'is successful' do
          expect(response.status).to eq(201)

          expect(response).to match_json_schema('user')

          expect(response.body).to match_json_payload(user_payload(User.last))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) do
          { user: { email: 'aaaaaaa', password: 'password', password_confirmation: 'password' } }
        end

        before(:each) do
          post url, params: invalid_params, headers: session_data_admin
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:email, 'errors.messages.invalid']))
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'post', '/api/v1/users'
    end
  end

  describe 'PUT /users/:id' do
    context 'authenticated as admin' do
      let!(:url) { "/api/v1/users/#{@staff_user.id}" }

      context 'with valid params' do
        let!(:valid_params) do
          { user: { email: 'aaa@bbb.ccc', password: 'password', password_confirmation: 'password' } }
        end

        before(:each) do
          put url, params: valid_params, headers: session_data_admin
        end

        it 'is successful' do
          expect(response.status).to eq(200)

          expect(response).to match_json_schema('user')

          @staff_user.email = 'aaa@bbb.ccc'
          expect(response.body).to match_json_payload(user_payload(@staff_user))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) do
          { user: { email: 'aaaaaa', password: 'password', password_confirmation: 'password' } }
        end

        before(:each) do
          put url, params: invalid_params, headers: session_data_admin
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:email, 'errors.messages.invalid']))
        end
      end
    end

    context 'authenticated as normal user' do
      let!(:url) { "/api/v1/users/#{@staff_user.id}" }

      context 'with valid params' do
        let!(:valid_params) do
          { user: { email: 'aaa@bbb.ccc', password: 'password', password_confirmation: 'password' } }
        end

        before(:each) do
          put url, params: valid_params, headers: session_data_user
        end

        it 'is successful' do
          expect(response.status).to eq(200)

          expect(response).to match_json_schema('user')

          @staff_user.email = 'aaa@bbb.ccc'
          expect(response.body).to match_json_payload(user_payload(@staff_user))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) { { user: { email: 'aaaa', password: 'password', password_confirmation: 'password' } } }

        before(:each) do
          put url, params: invalid_params, headers: session_data_admin
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:email, 'errors.messages.invalid']))
        end
      end

      context 'editing another user' do
        let!(:invalid_params) { { user: { email: 'aaaa', password: 'password', password_confirmation: 'password' } } }

        before(:each) do
          put url, params: invalid_params, headers: session_data_user
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'put', '/api/v1/users/9999'
    end
  end

  describe 'DELETE /users/:id' do
    let!(:url) { "/api/v1/users/#{user3.id}" }
    context 'authenticated as admin' do
      before(:each) do
        delete url, params: {}, headers: session_data_admin
      end

      it 'is successful' do
        expect(response.status).to eq(204)

        expect(response.body).to eq('')
      end
    end

    context 'authenticated as normal user' do
      before(:each) do
        delete url, params: {}, headers: session_data_user
      end

      it 'is successful' do
        expect(response.status).to eq(401)
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'delete', '/api/v1/users/9999'
    end
  end
end
