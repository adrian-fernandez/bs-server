require 'rails_helper'
RSpec.describe Api::V1::Repositories::BookingsRepository do
  let!(:user) { create(:user, client: @client) }

  describe '.visible_by' do
    let!(:rental) { create :rental, name: 'My sample rental' }
    let!(:rental2) { create :rental, name: 'Lorem Ipsum' }
    let!(:booking1) { create :booking, rental: rental, user: @staff_user }
    let!(:booking2) { create :booking, rental: rental2, user: @staff_user }
    let!(:booking3) { create :booking, rental: rental2, user: @staff_user }
    let!(:booking4) { create :booking, rental: rental, user: @admin_user }

    context 'when user is admin' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @admin_user
        )
      end

      it 'should see everything owned by its client' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking1.id,
            booking2.id,
            booking3.id,
            booking4.id
          ]
        )
      end
    end

    context 'when user is normal user' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client,
          current_user: @staff_user
        )
      end

      it 'should see bookings owned by himself' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            booking1.id,
            booking2.id,
            booking3.id
          ]
        )
      end
    end

    context 'when user is nil' do
      let!(:repository) do
        Api::V1::Repositories::BookingsRepository.new(
          current_client: @client
        )
      end

      it 'should not see anything' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end
  end

  describe '.search_filters' do
    it 'should return array of Filters' do
      expect(subject.send(:search_filters)).to eq(
        [
          Api::V1::Filters::BookingFilters::DateFilter,
          Api::V1::Filters::BookingFilters::FromFilter,
          Api::V1::Filters::BookingFilters::ToFilter,

          Api::V1::Filters::GenericFilters::QueryFilter,
          Api::V1::Filters::GenericFilters::IdsFilter,
          Api::V1::Filters::GenericFilters::ExcludeIdsFilter
        ]
      )
    end
  end

  describe '.service_name' do
    it 'should return the name of the service' do
      expect(subject.send(:service_name).to_s).to eq('Booking')
    end
  end

  describe '.sort_service' do
    it 'should return the name of the sorting service' do
      expect(subject.send(:sort_service).to_s).to eq('Api::V1::Sorters::BookingSorter')
    end
  end

  describe '.filter_service' do
    it 'should return the name of the filtering service' do
      expect(subject.send(:filter_service).to_s).to eq('Api::V1::Filters::BookingFilters')
    end
  end

  describe 'select fields' do
    context 'when there are selected fields' do
      let(:subject_with_params) { Api::V1::Repositories::BookingsRepository.new(params: { selected_fields: ['id'] }) }

      it '.select_fields? should return true' do
        expect(subject_with_params.send(:select_fields?)).to be_truthy
      end

      it '.selected_fields should an array of field names' do
        expect(subject_with_params.send(:selected_fields)).to eq(['id'])
      end
    end

    context 'when there are not selected fields' do
      it '.select_fields? should return false' do
        expect(subject.send(:select_fields?)).to be_falsey
      end

      it '.selected_fields should an empty array' do
        expect(subject.send(:selected_fields)).to eq([])
      end
    end
  end

  describe '.paginate?' do
    it 'should return true by default' do
      expect(subject.send(:paginate?)).to be_truthy
    end

    it 'should return false when it has param paginate=false' do
      subject_with_params = Api::V1::Repositories::BookingsRepository.new(params: { paginate: 'false' })

      expect(subject_with_params.send(:paginate?)).to be_falsey
    end
  end

  describe '.no_selectable_fields' do
    it 'should return an empty array' do
      expect(subject.send(:no_selectable_fields)).to eq([])
    end
  end
end
