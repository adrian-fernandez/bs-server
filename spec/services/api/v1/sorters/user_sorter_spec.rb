require 'rails_helper'
RSpec.describe Api::V1::Sorters::UserSorter do
  let!(:user1) { create(:user, email: 'aaa@aaa.aaa', roles: [@admin_role]) }
  let!(:user2) { create(:user, email: 'bbb@bbb.bbb') }
  let!(:user3) { create(:user, email: 'ddd@ddd.ddd') }
  let!(:user4) { create(:user, email: 'ccc@ccc.ccc') }

  describe 'Config values' do
    it '.sortable_felds' do
      expect(Api::V1::Sorters::UserSorter.sortable_fields).to eq(%w[email])
    end

    it '.direct_sorting_fields' do
      expect(Api::V1::Sorters::UserSorter.direct_sorting_fields).to eq(%w[email])
    end

    it '.default_sortbable_field' do
      expect(Api::V1::Sorters::UserSorter.default_sortable_field).to eq(:email)
    end

    it '.table_name' do
      expect(Api::V1::Sorters::UserSorter.table_name).to eq('users')
    end
  end

  describe '.sort' do
    context 'sort by email' do
      context 'asc' do
        let!(:repository) do
          Api::V1::Repositories::UsersRepository.new(
            current_client: @client,
            current_user: user1,
            params: { sort_field: 'email', sort_direction: 'asc' }
          )
        end

        it 'should return users filtered by emails' do
          result = repository.collection.pluck(:id)
          result.delete(@staff_user.id)
          result.delete(@admin_user.id)
          result.delete(@superadmin_user.id)

          expect(result).to eq(
            [
              user1.id,
              user2.id,
              user4.id,
              user3.id
            ]
          )
        end
      end

      context 'desc' do
        let!(:repository) do
          Api::V1::Repositories::UsersRepository.new(
            current_client: @client,
            current_user: user1,
            params: { sort_field: 'email', sort_direction: 'desc' }
          )
        end

        it 'should return users filtered by emails' do
          result = repository.collection.pluck(:id)
          result.delete(@staff_user.id)
          result.delete(@admin_user.id)
          result.delete(@superadmin_user.id)

          expect(result).to eq(
            [
              user3.id,
              user4.id,
              user2.id,
              user1.id
            ]
          )
        end
      end
    end
  end
end
