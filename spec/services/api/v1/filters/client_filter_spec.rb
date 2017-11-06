require 'rails_helper'
RSpec.describe Api::V1::Filters::ClientFilters do
  describe '.collection' do
    let!(:repository) do
      Api::V1::Repositories::ClientsRepository.new(
        current_client: @client,
        current_user: @staff_user
      )
    end

    it 'should return all the clients' do
      expect(repository.collection.pluck(:id).sort).to eq(
        [
          @client.id
        ]
      )
    end
  end

  describe 'QueryFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::ClientsRepository.new(
          current_client: @client,
          current_user: @superadmin_user,
          params: { q: 'name' }
        )
      end

      it 'should return clients filtered by name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @client.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::ClientsRepository.new(
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
        Api::V1::Repositories::ClientsRepository.new(
          current_client: @client,
          current_user: @staff_user,
          params: { name: 'nam' }
        )
      end

      it 'should return clients filtered by name' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @client.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::ClientsRepository.new(
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
end
