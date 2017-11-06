# Authentication credential declared in spec/support/api_and_public_api.rb
# @staff_role
# @staff_user
# @staff_user_session
# @client

require 'rails_helper'

describe 'Api::V1::BookingsController', type: :request do
  let!(:user2) { create :user, client: @client }
  let!(:rental1) { create :rental, name: 'Foo bar', user: user2, client: @client }
  let!(:rental2) { create :rental, name: 'Foo bar 2', user: user2, client: @client }
  let!(:rental3) { create :rental, name: 'Foo bar 3', user: user2, client: @client }
  let!(:booking1) { create :booking, rental: rental1, user: @staff_user, client: @client }
  let!(:booking2) { create :booking, rental: rental1, user: @staff_user, client: @client }
  let!(:booking3) { create :booking, rental: rental2, user: @staff_user, client: @client }
  let!(:session_data) do
    {
      '_BOOKINGSYNC_CURRENT_USER' => @staff_user,
      '_t' => @staff_user_session.access_token
    }
  end

  describe 'GET /bookings' do
    let!(:url) { '/api/v1/bookings' }

    context 'authenticated' do
      before(:each) do
        get url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('bookings')

        bookings = [booking1, booking2, booking3]
        expect(response.body).to match_json_payload(bookings_payload(bookings))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/bookings'
    end
  end

  describe 'GET /bookings/:id' do
    let!(:url) { "/api/v1/bookings/#{booking1.id}" }

    context 'authenticated' do
      before(:each) do
        get url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(200)

        expect(response).to match_json_schema('booking')

        expect(response.body).to match_json_payload(booking_payload(booking1))
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'get', '/api/v1/bookings/9999'
    end
  end

  describe 'POST /bookings' do
    let!(:url) { '/api/v1/bookings' }

    context 'authenticated' do
      context 'with valid params' do
        let!(:valid_params) do
          {
            booking: {
              rental_id: rental3.id,
              user_id: @staff_user.id,
              start_at: Date.today.to_date.to_s,
              end_at: (Date.today + 1.day).to_date.to_s
            }
          }
        end

        before(:each) do
          post url, params: valid_params, headers: session_data
        end

        it 'is successful' do
          expect(response.status).to eq(201)

          expect(response).to match_json_schema('booking')

          expect(response.body).to match_json_payload(booking_payload(Booking.order(id: :desc).first))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) do
          {
            booking: {
              rental_id: rental1.id,
              user_id: @staff_user.id,
              start_at: Date.today,
              end_at: ''
            }
          }
        end

        before(:each) do
          post url, params: invalid_params, headers: session_data
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(
            validation_error_payload([:end_at, ['errors.messages.invalid_date', 'errors.messages.blank']])
          )
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'post', '/api/v1/bookings'
    end
  end

  describe 'PUT /bookings/:id' do
    let!(:url) { "/api/v1/bookings/#{booking1.id}" }

    context 'authenticated' do
      context 'with valid params' do
        let!(:valid_params) do
          {
            booking: {
              rental_id: rental1.id,
              user_id: @staff_user.id,
              start_at: Date.today,
              end_at: Date.today + 1.day
            }
          }
        end

        before(:each) do
          put url, params: valid_params, headers: session_data
        end

        it 'is successful' do
          expect(response.status).to eq(200)

          expect(response).to match_json_schema('booking')

          expect(response.body).to match_json_payload(booking_payload(Booking.find(booking1.id)))
        end
      end

      context 'with invalid params' do
        let!(:invalid_params) do
          {
            booking: {
              rental_id: rental1.id,
              user_id: @staff_user.id,
              start_at: Date.today,
              end_at: ''
            }
          }
        end

        before(:each) do
          put url, params: invalid_params, headers: session_data
        end

        it 'is unprocessable' do
          expect(response.status).to eq(422)

          expect(response).to match_json_schema('validation_error')

          expect(response.body).to match_json_payload(
            validation_error_payload([:end_at, ['errors.messages.invalid_date', 'errors.messages.blank']])
          )
        end
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'put', '/api/v1/bookings/9999'
    end
  end

  describe 'DELETE /bookings/:id' do
    let!(:url) { "/api/v1/bookings/#{booking1.id}" }

    context 'authenticated' do
      before(:each) do
        delete url, params: {}, headers: session_data
      end

      it 'is successful' do
        expect(response.status).to eq(204)

        expect(response.body).to eq('')

        expect(Booking.where(id: booking1.id).first).to be_nil
      end
    end

    context 'not authenticated' do
      it_behaves_like 'forbidden', 'delete', '/api/v1/bookings/9999'
    end
  end
end
