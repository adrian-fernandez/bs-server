require 'rails_helper'
RSpec.describe Api::V1::Filters::UserFilters do
  let!(:user2) { create(:user, email: 'bbb@bbb.bbb') }
  let!(:user3) { create(:user, email: 'ccc@ccc.ccc') }
  let!(:user4) { create(:user, email: 'ddd@ddd.ddd') }

  describe '.collection' do
    let!(:repository) do
      Api::V1::Repositories::UsersRepository.new(
        current_client: @client,
        current_user: @admin_user
      )
    end

    it 'should return all the users of client' do
      expect(repository.collection.pluck(:id).sort).to eq(
        [
          @admin_user.id,
          @staff_user.id,
          @superadmin_user.id,
          user2.id,
          user3.id,
          user4.id
        ]
      )
    end
  end

  describe 'QueryFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { q: 'ddd' }
        )
      end

      it 'should return users filtered by email' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            user4.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
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

  describe 'EmailFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { email: @admin_user.email[0..3] }
        )
      end

      it 'should return users filtered by email' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @admin_user.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { email: 'abcd' }
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

  describe 'ExcludeRoleIdsFilter' do
    context 'looking for all' do
      context 'when find matches' do
        let!(:repository) do
          Api::V1::Repositories::UsersRepository.new(
            current_client: @client,
            current_user: @admin_user,
            params: { exclude_role_ids: @admin_user.role_ids.last }
          )
        end

        it 'should return users filtered by roles' do
          expect(repository.collection.pluck(:id).sort.uniq).to eq(
            [
              @staff_user.id,
              @superadmin_user.id,
              user2.id,
              user3.id,
              user4.id
            ]
          )
        end
      end

      context 'when no find matches' do
        let!(:repository) do
          Api::V1::Repositories::UsersRepository.new(
            current_client: @client,
            current_user: @admin_user,
            params: { exclude_role_ids: [
              @admin_user.role_ids.last, user2.role_ids.last, user3.role_ids.last, user4.role_ids.last
            ] }
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

  describe 'IdsFilter' do
    context 'when find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { ids: [@admin_user.id, user2.id] }
        )
      end

      it 'should return users filtered by ids' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @admin_user.id,
            user2.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
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
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { exclude_ids: @admin_user.id }
        )
      end

      it 'should return users filtered by user id' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @staff_user.id,
            @superadmin_user.id,
            user2.id,
            user3.id,
            user4.id
          ]
        )
      end
    end

    context 'when no find matches' do
      let!(:repository) do
        Api::V1::Repositories::UsersRepository.new(
          current_client: @client,
          current_user: @admin_user,
          params: { exclude_ids: [@admin_user.id, user2.id, user3.id, user4.id] }
        )
      end

      it 'should return empty collection' do
        expect(repository.collection.pluck(:id).sort).to eq(
          [
            @staff_user.id,
            @superadmin_user.id
          ]
        )
      end
    end
  end
end
