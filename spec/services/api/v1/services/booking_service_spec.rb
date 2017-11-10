require 'rails_helper'
RSpec.describe Api::V1::Services::BookingService do
  let!(:user) { create(:user, email: 'aaa@aaa.aaa') }

  let!(:rental) { create :rental, name: 'A Rental', daily_rate: 10 }

  describe '.class_name' do
    let!(:service) do
      Api::V1::Services::BookingService.new
    end

    it 'should return the name of the associated class' do
      expect(service.send(:class_name)).to eq(Booking)
    end
  end

  describe '.repository' do
    let!(:service) do
      Api::V1::Services::BookingService.new(
        current_client: @client,
        current_user: user
      )
    end

    it 'should return Api::V1::Repositories::BookingsRepository' do
      expect(service.send(:repository)).to eq(Api::V1::Repositories::BookingsRepository)
    end
  end

  describe '.create' do
    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          current_client: @client,
          current_user: user,
          params: { booking: { rental_id: rental.id, start_at: Date.current, end_at: Date.current + 2.days } }
        )
      end

      it 'should create the object and return true' do
        expect(service.create).to be_truthy
        expect(Booking.count).to eq(1)

        created_object = Booking.last
        expect(created_object).to eq(service.item)
        expect(created_object.user_id).to eq(user.id)
        expect(created_object.client_id).to eq(@client.id)
        expect(created_object.start_at).to eq(Date.current)
        expect(created_object.end_at).to eq(Date.current + 2.days)
        expect(created_object.days).to eq(2)
        expect(created_object.price).to eq(20)
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          current_client: @client,
          current_user: user,
          params: { booking: { rental_id: rental.id, end_at: Date.current + 2.days } }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(Booking.count).to eq(0)
        expect(service.item.errors.messages.keys).to eq(%i[start_at end_at])
        expect(service.item.errors.messages[:start_at]).to eq(["can't be blank"])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          current_client: @client,
          current_user: user,
          params: { rental_id: rental.id, end_at: Date.current + 2.days }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(Booking.count).to eq(0)
        expect(service.item).to be_nil
      end
    end
  end

  describe '.update' do
    let!(:booking) do
      create :booking,
             start_at: Date.current,
             end_at: Date.current + 2.days,
             rental: rental,
             user: user,
             client: @client
    end

    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          item: booking,
          current_client: @client,
          current_user: user,
          params: { booking: { end_at: Date.current + 3.days } }
        )
      end

      it 'should update the object and return true' do
        expect(service.update).to be_truthy
        expect(Booking.count).to eq(1)

        updated_object = Booking.last
        expect(updated_object).to eq(service.item)
        expect(updated_object.user_id).to eq(user.id)
        expect(updated_object.client_id).to eq(@client.id)
        expect(updated_object.start_at).to eq(Date.current)
        expect(updated_object.end_at).to eq(Date.current + 3.days)
        expect(updated_object.days).to eq(3)
        expect(updated_object.price).to eq(30)
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          item: booking,
          current_client: @client,
          current_user: user,
          params: { booking: { rental_id: rental.id, end_at: Date.current - 2.days } }
        )
      end

      it 'should not update anything and return false' do
        expect(service.update).to be_falsey

        expect(service.item.end_at).to eq(Date.current + 2.days)
        expect(Booking.count).to eq(1)
        expect(service.item.errors.messages.keys).to eq([:end_at])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::BookingService.new(
          item: booking,
          current_client: @client,
          current_user: user,
          params: { rental_id: rental.id, end_at: Date.current + 2.days }
        )
      end

      it 'should not update anything and return false' do
        expect { service.update }.to raise_error(
          ActionController::ParameterMissing,
          'param is missing or the value is empty: booking'
        )
        expect(Booking.count).to eq(1)
        updated_object = Booking.last

        expect(service.item).to eq(updated_object)
        expect(service.item.end_at).to eq(Date.current + 2.days)
      end
    end
  end

  describe '.destroy' do
    let!(:booking) do
      create :booking,
             start_at: Date.current,
             end_at: Date.current + 2.days,
             rental: rental,
             user: user
    end

    let!(:service) do
      Api::V1::Services::BookingService.new(
        item: booking,
        current_client: @client,
        current_user: user
      )
    end

    it 'should destroy the object and return true' do
      expect(service.destroy).to be_truthy

      expect(Booking.count).to eq(0)
    end
  end
end
