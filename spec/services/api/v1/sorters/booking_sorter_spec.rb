require 'rails_helper'
RSpec.describe Api::V1::Sorters::BookingSorter do
  let!(:user) { create(:user, email: 'aaa@aaa.aaa', roles: [@admin_role]) }
  let!(:user2) { create(:user, email: 'bbb@bbb.bbb') }
  let!(:user3) { create(:user, email: 'ccc@ccc.ccc') }
  let!(:user4) { create(:user, email: 'ddd@ddd.ddd') }

  let!(:rental) { create :rental, name: 'A Rental', daily_rate: 10 }
  let!(:rental2) { create :rental, name: 'B Rental', daily_rate: 100 }
  let!(:rental3) { create :rental, name: 'C Rental', daily_rate: 100 }
  let!(:rental4) { create :rental, name: 'D Rental', daily_rate: 100 }

  let!(:booking1) do
    create :booking,
           rental: rental,
           start_at: Date.today - 1.day,
           end_at: Date.today,
           user: user,
           client: @client
  end

  let!(:booking2) do
    create :booking,
           rental: rental2,
           start_at: Date.today,
           end_at: Date.today + 2.day,
           user: user2,
           client: @client
  end

  let!(:booking3) do
    create :booking,
           rental: rental3,
           start_at: Date.today + 1.day,
           end_at: Date.today + 4.days,
           user:  user3,
           client: @client
  end

  let!(:booking4) do
    create :booking,
           rental: rental4,
           start_at: Date.today - 1.month,
           end_at: Date.today + 2.months,
           user: user4,
           client: @client
  end

  describe 'Config values' do
    it '.sortable_felds' do
      expect(Api::V1::Sorters::BookingSorter.sortable_fields).to eq(%w[rental user start_at end_at days])
    end

    it '.direct_sorting_fields' do
      expect(Api::V1::Sorters::BookingSorter.direct_sorting_fields).to eq(%w[start_at end_at days price])
    end

    it '.default_sortbable_field' do
      expect(Api::V1::Sorters::BookingSorter.default_sortable_field).to eq(:start_at)
    end

    it '.table_name' do
      expect(Api::V1::Sorters::BookingSorter.table_name).to eq('bookings')
    end
  end

  describe '.sort' do
    context 'sort by rental' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'rental', sort_direction: 'asc' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking1.id,
              booking2.id,
              booking3.id,
              booking4.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'rental', sort_direction: 'desc' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking4.id,
              booking3.id,
              booking2.id,
              booking1.id
            ]
          )
        end
      end
    end

    context 'sort by user' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'user', sort_direction: 'asc' }
          )
        end

        it 'should return bookings filtered by users name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking1.id,
              booking2.id,
              booking3.id,
              booking4.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'user', sort_direction: 'desc' }
          )
        end

        it 'should return bookings filtered by users name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking4.id,
              booking3.id,
              booking2.id,
              booking1.id
            ]
          )
        end
      end
    end

    context 'sort by start_at' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'start_at', sort_direction: 'asc' }
          )
        end

        it 'should return bookings filtered by rentals name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking4.id,
              booking1.id,
              booking2.id,
              booking3.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'start_at', sort_direction: 'desc' }
          )
        end

        it 'should return bookings filtered by start_at' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking3.id,
              booking2.id,
              booking1.id,
              booking4.id
            ]
          )
        end
      end
    end

    context 'sort by end_at' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'end_at', sort_direction: 'asc' }
          )
        end

        it 'should return bookings filtered by end_at' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking1.id,
              booking2.id,
              booking3.id,
              booking4.id
            ]
          )
        end
      end

      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'end_at', sort_direction: 'desc' }
          )
        end

        it 'should return bookings filtered by end_at' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking4.id,
              booking3.id,
              booking2.id,
              booking1.id
            ]
          )
        end
      end
    end

    context 'sort by days' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'days', sort_direction: 'asc' }
          )
        end

        it 'should return bookings filtered by number of days' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking1.id,
              booking2.id,
              booking3.id,
              booking4.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::BookingsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'days', sort_direction: 'desc' }
          )
        end

        it 'should return bookings filtered by number of days' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              booking4.id,
              booking3.id,
              booking2.id,
              booking1.id
            ]
          )
        end
      end
    end
  end
end
