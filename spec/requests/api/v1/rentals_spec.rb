# Authentication credential declared in spec/support/api_and_public_api.rb
# @staff_role
# @staff_user
# @staff_user_session

require 'rails_helper'

describe 'Api::V1::RentalsController', type: :request do
  let!(:rental1) { create :rental, name: 'Foo bar', user: @staff_user }
  let!(:rental2) { create :rental, user: @staff_user }
  let!(:rental3) { create :rental, user: @staff_user, name: 'Foo another bar' }
  let!(:session_data) do
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

  describe 'GET /rentals' do
    let!(:url) { '/api/v1/rentals' }

    context 'authenticated' do
      before(:each) do
        get url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('rentals')

        rentals = [rental1, rental2, rental3]
        expect(response.body).to match_json_payload(rentals_payload(rentals))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/rentals'
    end
  end

  describe 'GET /rentals/:id' do
    let!(:url) { "/api/v1/rentals/#{rental1.id}" }

    context 'authenticated' do
      before(:each) do
        get url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('rental')

        expect(response.body).to match_json_payload(rental_payload(rental1))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/rentals/9999'
    end
  end

  describe 'POST /rentals' do
    let!(:url) { '/api/v1/rentals' }

    context 'authenticated' do
      context 'with valid params' do
        let!(:valid_params) { { rental: { name: 'Name for Rental', user_id: @staff_user.id, daily_rate: 1.12 } } }

        before(:each) do
          post url, params: valid_params, headers: session_data
        end

        it 'is successful' do
          expect(response.status).to eq(201)

          expect(response).to match_json_schema('rental')

          expect(response.body).to match_json_payload(rental_payload(Rental.last))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) { { rental: { name: '', daily_rate: 3, user_id: @staff_user.id } } }

        before(:each) do
          post url, params: invalid_params, headers: session_data
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:name, 'errors.messages.blank']))
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'post', '/api/v1/rentals'
    end
  end

  describe 'PUT /rentals/:id' do
    let!(:url) { "/api/v1/rentals/#{rental1.id}" }

    context 'authenticated' do
      context 'with valid params' do
        let!(:valid_params) { { rental: { name: 'New name for rental1' } } }

        before(:each) do
          put url, params: valid_params, headers: session_data
        end

        it 'is successful' do
          expect(response.status).to eq(200)

          expect(response).to match_json_schema('rental')

          expect(response.body).to match_json_payload(rental_payload(Rental.find(rental1.id)))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) { { rental: { name: '' } } }

        before(:each) do
          put url, params: invalid_params, headers: session_data
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(validation_error_payload([:name, 'errors.messages.blank']))
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'put', '/api/v1/rentals/9999'
    end
  end

  describe 'DELETE /rentals/:id' do
    let!(:url) { "/api/v1/rentals/#{rental1.id}" }

    context 'authenticated' do
      before(:each) do
        delete url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(204)

        expect(response.body).to eq('')

        expect(Rental.where(id: rental1.id).first).to be_nil
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'delete', '/api/v1/rentals/9999'
    end
  end
end
