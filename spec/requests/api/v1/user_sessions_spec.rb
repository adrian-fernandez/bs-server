# Authentication credential declared in spec/support/api_and_public_api.rb
# @staff_role
# @staff_user
# @staff_user_session

require 'rails_helper'

describe Api::V1::UserSessionsController, type: :request do
  let!(:session_data_superadmin) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @superadmin_user,
      '_t' => @superadmin_user_session.access_token
    }
  end

  let!(:session_data_admin) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @admin_user,
      '_t' => @staff_user_session.access_token
    }
  end

  let!(:session_data_customer) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @staff_user,
      '_t' => @staff_user_session.access_token,
      'X-Auth-Token' => @staff_user_session.access_token
    }
  end

  describe 'POST /user_sessions' do
    let!(:url) { '/api/v1/user_sessions.json' }

    context 'with valid credentials' do
      let(:valid_params) { { session: { email: @staff_user.email, password: 'password' } } }

      context 'with valid params' do
        before(:each) do
          post url, params: valid_params, headers: {}
        end

        it 'is successful' do
          expect(response.status).to eq(201)

          expect(response).to match_json_schema('user_session')

          expect(response.body).to match_json_payload(
            user_session_payload(UserSession.find_by(user_id: @staff_user.id), @staff_user)
          )
        end
      end
    end

    context 'with invalid credentials' do
      context 'with wrong email' do
        let(:wrong_email_params) { { session: { email: 'bad@email.es', password: 'password' } } }
        before(:each) do
          post url, params: wrong_email_params, headers: {}
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(
            validation_error_payload(session: 'flashes.user_session.bad_email_password')
          )
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { session: { email: @staff_user.email, password: 'bad_password', format: :json } } }
        before(:each) do
          post url, params: invalid_params, headers: {}
        end

        it 'returns bad password error' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(
            validation_error_payload(session: 'flashes.user_session.bad_email_password')
          )
        end

        it 'should lock account after many fails' do
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(1)

          post url, params: invalid_params, headers: {}
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(2)

          post url, params: invalid_params, headers: {}
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(3)

          post url, params: invalid_params, headers: {}
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(4)

          post url, params: invalid_params, headers: {}
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(5)
          expect(@staff_user.auth_locked_at.to_date).to eq(Date.current)

          post url, params: invalid_params, headers: {}
          expect(response.body).to match_json_payload(
            validation_error_payload(session: 'flashes.user_session.auth_locked')
          )

          @staff_user.unlock_authorization!
          @staff_user.reload
          expect(@staff_user.auth_failed_attempts).to eq(0)
          expect(@staff_user.auth_locked_at).to be_nil
        end
      end
    end
  end
end
