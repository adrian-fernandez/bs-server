require 'rails_helper'
RSpec.describe Api::V1::Filters::RentalFilters do
  let!(:rental1) { create :rental, name: 'My sample rental', user: @staff_user, daily_rate: 5 }
  let!(:rental2) { create :rental, name: 'Lorem Ipsum', user: @staff_user, daily_rate: 10 }
  let!(:rental3) { create :rental, name: 'Lorem Ipsum2', user: @superadmin_user, daily_rate: 15 }
  let!(:rental4) { create :rental, name: 'Lorem Ipsum3', user: @admin_user, daily_rate: 20 }

  describe '.collection' do
    let!(:repository) do
      Api::V1::Repositories::RentalsRepository.new(
        current_client: @client,
        current_user: @staff_user
      )
    end

    it 'should return all the rentals of client' do
      expect(repository.collection.pluck(:id).sort).to eq(
        [
          rental1.id,
          rental2.id,
          rental3.id,
          rental4.id
        ]
      )
    end
  end

  describe 'QueryFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'sample rental' }
        )
      end

      it 'should return rentals filtered by rentals and user name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental1.id
          ]
        )
      end
    end

    context 'when find matches in nested class' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'aaa' }
        )
      end

      it 'should return rentals filtered by rentals and user name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end

    context 'when find matches in nested class and its included in the search fields' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'aaa', search_fields: %w[users.email] }
        )
      end

      it 'should return rentals filtered by rentals and user name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end

    context 'when find matches in nested class but the class is not included in search' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { q: 'aaa', search_fields: %w[name] }
        )
      end

      it 'should return empty array' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
          ]
        )
      end
    end

    context 'when pass invalid search_fields' do
      it 'should return empty array' do
        expect {
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: @staff_user,
            params: { q: 'aaa', search_fields: %w[wrong_field] }
          )
        }.to raise_error(
          ArgumentError,
          'Trying to do a fuzzy search with invalid parameters: ["wrong_field"]'
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
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

  describe 'NameFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { name: 'sample' }
        )
      end

      it 'should return rentals filtered by name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental1.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { name: 'abcd' }
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

  describe 'UserFilter' do
    context 'looking for all' do
      context 'when find matches' do
        let!(:repository) do
          Api::V1::Repositories::RentalsRepository.new(
            current_client: @client,
            current_user: @staff_user,
            params: { user_filter: @staff_user.id }
          )
        end

        it 'should return rentals filtered by rentals name' do
          expect(repository.collection.pluck(:id).sort).to eq(
            [
              rental1.id,
              rental2.id
            ]
          )
        end
      end
    end
  end

  describe 'PriceFromFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { price_from_filter: 10 }
        )
      end

      it 'should return rentals filtered by rentals name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental2.id,
            rental3.id,
            rental4.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { price_from_filter: 100 }
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

  describe 'PriceToFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { price_to_filter: 10 }
        )
      end

      it 'should return rentals filtered by rentals name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental1.id,
            rental2.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { price_to_filter: 4.99 }
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
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { ids: [rental1.id, rental2.id] }
        )
      end

      it 'should return rentals filtered by ids' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental1.id,
            rental2.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
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
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { exclude_ids: rental1.id }
        )
      end

      it 'should return rentals filtered by user id' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            rental2.id,
            rental3.id,
            rental4.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::RentalsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { exclude_ids: [rental1.id, rental2.id, rental3.id, rental4.id] }
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
