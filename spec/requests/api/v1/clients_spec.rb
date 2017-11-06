# Authentication credential declared in spec/support/api_and_public_api.rb
# @staff_role
# @staff_user
# @staff_user_session

require 'rails_helper'

describe Api::V1::ClientsController, type: :request do
  let!(:session_data_superadmin) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @superadmin_user,
      '_t' => @superadmin_user_session.access_token
    }
  end

  let!(:session_data_admin) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @staff_user,
      '_t' => @staff_user_session.access_token
    }
  end

  let!(:session_data_customer) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @staff_user,
      '_t' => @staff_user_session.access_token
    }
  end

  describe 'GET /clients' do
    let!(:url) { '/api/v1/clients' }

    context 'authenticated as superadmin' do
      before(:each) do
        get url, params: {}, headers: session_data_superadmin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('clients')

        expect(response.body).to match_json_payload(clients_payload([@client]))
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it_behaves_like 'forbidden', 'get', '/api/v1/clients'
    end

    context 'authenticated as normal client' do
      before(:each) do
        get url, params: {}, headers: session_data_customer
      end

      it_behaves_like 'forbidden', 'get', '/api/v1/clients'
    end
  end

  describe 'GET /clients/:id' do
    let!(:url) { "/api/v1/clients/#{@client.id}" }

    context 'authenticated as superadmin' do
      before(:each) do
        get url, params: {}, headers: session_data_superadmin
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('client')

        expect(response.body).to match_json_payload(client_payload(@client))
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        get url, params: {}, headers: session_data_admin
      end

      it_behaves_like 'forbidden', 'get', '/api/v1/clients/9999'
    end

    context 'authenticated as normal client' do
      before(:each) do
        get url, params: {}, headers: session_data_customer
      end

      it_behaves_like 'forbidden', 'get', '/api/v1/clients/9999'
    end
  end

  describe 'POST /clients' do
    let!(:url) { '/api/v1/clients' }
    let(:valid_params) { { client: { name: 'test name' } } }

    context 'authenticated as superadmin' do
      context 'with valid params' do
        before(:each) do
          post url, params: valid_params, headers: session_data_superadmin
        end

        it 'is successful' do
          expect(response.status).to eq(201)

          expect(response).to match_json_schema('client')

          expect(response.body).to match_json_payload(client_payload(Client.last))
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { client: { name: '' } } }
        before(:each) do
          post url, params: invalid_params, headers: session_data_superadmin
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:name, 'errors.messages.blank']))
        end
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        post url, params: valid_params, headers: session_data_admin
      end

      it_behaves_like 'forbidden', 'post', '/api/v1/clients'
    end

    context 'authenticated as normal client' do
      before(:each) do
        post url, params: valid_params, headers: session_data_customer
      end

      it_behaves_like 'forbidden', 'post', '/api/v1/clients'
    end
  end

  describe 'PUT /clients/:id' do
    let!(:url) { "/api/v1/clients/#{@client.id}" }
    let(:valid_params) { { client: { name: 'test name' } } }

    context 'authenticated as superadmin' do
      context 'with valid params' do
        before(:each) do
          put url, params: valid_params, headers: session_data_superadmin
        end

        it 'is successful' do
          expect(response.status).to eq(200)

          expect(response).to match_json_schema('client')

          @client.name = 'test name'
          expect(response.body).to match_json_payload(client_payload(@client))
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { client: { name: '' } } }
        before(:each) do
          put url, params: invalid_params, headers: session_data_superadmin
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:name, 'errors.messages.blank']))
        end
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        put url, params: valid_params, headers: session_data_admin
      end

      it_behaves_like 'forbidden', 'put', '/api/v1/clients/9999'
    end

    context 'authenticated as normal client' do
      before(:each) do
        put url, params: valid_params, headers: session_data_customer
      end

      it_behaves_like 'forbidden', 'put', '/api/v1/clients/9999'
    end
  end

  describe 'DELETE /clients/:id' do
    let!(:url) { "/api/v1/clients/#{@client.id}" }

    context 'authenticated as superadmin' do
      before(:each) do
        delete url, params: {}, headers: session_data_superadmin
      end

      it 'is successful' do
        expect(response.status).to eq(204)

        expect(response.body).to eq('')

        expect(Client.where(id: @client.id).first).to be_nil
      end
    end

    context 'authenticated as admin' do
      before(:each) do
        delete url, params: {}, headers: session_data_admin
      end

      it_behaves_like 'forbidden', 'delete', '/api/v1/clients/9999'
    end

    context 'authenticated as normal client' do
      before(:each) do
        delete url, params: {}, headers: session_data_customer
      end

      it_behaves_like 'forbidden', 'delete', '/api/v1/clients/9999'
    end
  end
end
