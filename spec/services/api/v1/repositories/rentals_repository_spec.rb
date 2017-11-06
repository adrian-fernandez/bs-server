require 'rails_helper'
RSpec.describe Api::V1::Repositories::RentalsRepository do
  describe '.search_filters' do
    it 'should return array of Filters' do
      expect(subject.send(:search_filters)).to eq(
        [
          Api::V1::Filters::RentalFilters::NameFilter,
          Api::V1::Filters::RentalFilters::UserFilter,
          Api::V1::Filters::RentalFilters::PriceFromFilter,
          Api::V1::Filters::RentalFilters::PriceToFilter,

          Api::V1::Filters::GenericFilters::QueryFilter,
          Api::V1::Filters::GenericFilters::IdsFilter,
          Api::V1::Filters::GenericFilters::ExcludeIdsFilter
        ]
      )
    end
  end

  describe '.service_name' do
    it 'should return the name of the service' do
      expect(subject.send(:service_name).to_s).to eq('Rental')
    end
  end

  describe '.sort_service' do
    it 'should return the name of the sorting service' do
      expect(subject.send(:sort_service).to_s).to eq('Api::V1::Sorters::RentalSorter')
    end
  end

  describe '.filter_service' do
    it 'should return the name of the filtering service' do
      expect(subject.send(:filter_service).to_s).to eq('Api::V1::Filters::RentalFilters')
    end
  end

  describe 'select fields' do
    context 'when there are selected fields' do
      let(:subject_with_params) { Api::V1::Repositories::RentalsRepository.new(params: { selected_fields: ['id'] }) }

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
      subject_with_params = Api::V1::Repositories::RentalsRepository.new(params: { paginate: 'false' })

      expect(subject_with_params.send(:paginate?)).to be_falsey
    end
  end

  describe '.no_selectable_fields' do
    it 'should return an empty array' do
      expect(subject.send(:no_selectable_fields)).to eq([])
    end
  end
end
