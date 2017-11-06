require 'rails_helper'
RSpec.describe Api::V1::Sorters::RentalSorter do
  let!(:user) { create(:user, email: 'aaa@aaa.aaa', roles: [@admin_role]) }
  let!(:user2) { create(:user, email: 'bbb@bbb.bbb') }
  let!(:user3) { create(:user, email: 'ccc@ccc.ccc') }
  let!(:user4) { create(:user, email: 'ddd@ddd.ddd') }

  let!(:rental1) { create :rental, name: 'A Rental', user: user2, daily_rate: 10 }
  let!(:rental2) { create :rental, name: 'B Rental', user: user, daily_rate: 100 }
  let!(:rental3) { create :rental, name: 'C Rental', user: user3, daily_rate: 150 }
  let!(:rental4) { create :rental, name: 'D Rental', user: user4, daily_rate: 25 }

  describe 'Config values' do
    it '.sortable_felds' do
      expect(Api::V1::Sorters::RentalSorter.sortable_fields).to eq(%w[name user daily_rate])
    end

    it '.direct_sorting_fields' do
      expect(Api::V1::Sorters::RentalSorter.direct_sorting_fields).to eq(%w[name daily_rate])
    end

    it '.default_sortbable_field' do
      expect(Api::V1::Sorters::RentalSorter.default_sortable_field).to eq(:name)
    end

    it '.table_name' do
      expect(Api::V1::Sorters::RentalSorter.table_name).to eq('rentals')
    end
  end

  describe '.sort' do
    context 'sort by name' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'name', sort_direction: 'asc' }
          )
        end

        it 'should return rentals filtered by name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental1.id,
              rental2.id,
              rental3.id,
              rental4.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'name', sort_direction: 'desc' }
          )
        end

        it 'should return rentals filtered by name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental4.id,
              rental3.id,
              rental2.id,
              rental1.id
            ]
          )
        end
      end
    end

    context 'sort by user' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'user', sort_direction: 'asc' }
          )
        end

        it 'should return rentals filtered by users name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental2.id,
              rental1.id,
              rental3.id,
              rental4.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'user', sort_direction: 'desc' }
          )
        end

        it 'should return rentals filtered by users name' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental4.id,
              rental3.id,
              rental1.id,
              rental2.id
            ]
          )
        end
      end
    end

    context 'sort by daily_rate' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'daily_rate', sort_direction: 'asc' }
          )
        end

        it 'should return rentals filtered by daily_rate' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental1.id,
              rental4.id,
              rental2.id,
              rental3.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: user,
            params: { sort_field: 'daily_rate', sort_direction: 'desc' }
          )
        end

        it 'should return rentals filtered by daily_rate' do
          expect(repository.collection.pluck(:id)).to eq(
            [
              rental3.id,
              rental2.id,
              rental4.id,
              rental1.id
            ]
          )
        end
      end
    end
  end
end
