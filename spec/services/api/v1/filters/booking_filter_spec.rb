require 'rails_helper'
RSpec.describe Api::V1::Filters::BookingFilters do
  let!(:rental) { create :rental, name: 'My sample rental' }
  let!(:rental2) { create :rental, name: 'Lorem Ipsum' }
  let!(:booking1) do
    create :booking,
           rental: rental,
           start_at: Date.today - 1.day,
           end_at: Date.today,
           user: @staff_user
  end
  let!(:booking2) do
    create :booking,
           rental: rental2,
           start_at: Date.today,
           end_at: Date.today + 1.day,
           user: @staff_user
  end
  let!(:booking3) do
    create :booking,
           rental: rental2,
           start_at: Date.today + 1.day,
           end_at: Date.today + 2.days,
           user: @staff_user
  end
  let!(:booking4) do
    create :booking,
           rental: rental,
           start_at: Date.today - 1.month,
           end_at: Date.today + 2.months
  end

  describe '.collection' do
    let!(:repository) do
      Api::V1::Repositories::BookingsRepository.new(
        current_client: @client,
        current_user: @staff_user
      )
    end

    it 'should return all the bookings of client' do
      expect(repository.collection.pluck(:id).sort).to eq(
        [
          booking1.id,
          booking2.id,
          booking3.id
        ]
      )
    end
  end

  describe 'QueryFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'sample' }
        )
      end

      it 'should return bookings filtered by name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking1.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'abcd' }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end

  describe 'DateFilter' do
    context 'looking for all' do
      context 'when find matches' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: @staff_user,
            params: { date_filter: 'all' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id).sort).to eq(
            [
              booking1.id,
              booking2.id,
              booking3.id
            ]
          )
        end
      end
    end

    context 'looking for expired' do
      context 'when find matches' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: @staff_user,
            params: { date_filter: 'expired' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id).sort).to eq(
            [
              booking1.id
            ]
          )
        end
      end
    end

    context 'looking for upcoming' do
      context 'when find matches' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: @staff_user,
            params: { date_filter: 'upcoming' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id).sort).to eq(
            [
              booking2.id,
              booking3.id
            ]
          )
        end
      end
    end
  end

  describe 'FromFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { from_filter: Date.current.strftime('%Y-%m-%d') }
        )
      end

      it 'should return bookings filtered by rentals name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking2.id,
            booking3.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { from_filter: (Date.current + 2.days).strftime('%Y-%m-%d') }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end

  describe 'ToFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { to_filter: Date.current.strftime('%Y-%m-%d') }
        )
      end

      it 'should return bookings filtered by rentals name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking1.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { to_filter: (Date.current - 2.days).strftime('%Y-%m-%d') }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end

  describe 'IdsFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { ids: [booking1.id, booking2.id] }
        )
      end

      it 'should return bookings filtered by ids' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking1.id,
            booking2.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { ids: [-1] }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end

  describe 'ExcludeIdsFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { exclude_ids: booking1.id }
        )
      end

      it 'should return bookings filtered by booking id' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking2.id,
            booking3.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { exclude_ids: [booking1.id, booking2.id, booking3.id, booking4.id] }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end
end
