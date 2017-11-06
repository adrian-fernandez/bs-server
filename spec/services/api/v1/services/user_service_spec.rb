require 'rails_helper'
RSpec.describe Api::V1::Services::UserService do
  let!(:user) { create(:user, email: 'aaa@aaa.aaa', roles: [@staff_role, @admin_role] ) }

  describe '.class_name' do
    let!(:service) do
      Api::V1::Services::UserService.new
    end

    it 'should return the name of the associated class' do
      expect(service.send(:class_name)).to eq(User)
    end
  end

  describe '.repository' do
    let!(:service) do
      Api::V1::Services::UserService.new(
        current_client: @client,
        current_user: user
      )
    end

    it 'should return Api::V1::Repositories::UsersRepository' do
      expect(service.send(:repository)).to eq(Api::V1::Repositories::UsersRepository)
    end
  end

  describe '.create' do
    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          current_client: @client,
          current_user: user,
          params: { user: { email: 'aaa@bbb.ccc', password: 'password', password_confirmation: 'password' } }
        )
      end

      it 'should create the object and return true' do
        expect(service.create).to be_truthy
        expect(User.count).to eq(5)

        created_object = User.last
        expect(created_object).to eq(service.item)
        expect(created_object.client_id).to eq(@client.id)
        expect(created_object.email).to eq('aaa@bbb.ccc')
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          current_client: @client,
          current_user: user,
          params: { user: { email: 'test@test.com', password: 'password', password_confirmation: 'abcdef' } }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(User.count).to eq(4)
        expect(service.item.errors.messages.keys).to eq([:password_confirmation])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          current_client: @client,
          current_user: user,
          params: { email: 'aaa@bbb.ccc', password: 'password', password_confirmation: 'password' }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(User.count).to eq(4)
        expect(service.item).to be_nil
      end
    end
  end

  describe '.update' do
    let!(:user2) do
      create :user,
             email: 'aaa@bbb.ccc',
             password: 'password',
             password_confirmation: 'password',
             client: @client
    end

    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          item: user2,
          current_client: @client,
          current_user: user,
          params: { user: { email: 'zzz@zzz.zzz' } }
        )
      end

      it 'should update the object and return true' do
        expect(service.update).to be_truthy
        expect(User.count).to eq(5)

        updated_object = User.last
        expect(updated_object).to eq(service.item)
        expect(updated_object.client_id).to eq(@client.id)
        expect(updated_object.email).to eq('zzz@zzz.zzz')
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          item: user2,
          current_client: @client,
          current_user: user,
          params: { user: { email: '' } }
        )
      end

      it 'should not update anything and return false' do
        expect(service.update).to be_falsey
        expect(service.item.email).to eq('aaa@bbb.ccc')
        expect(User.count).to eq(5)
        expect(service.item.errors.messages.keys).to eq([:email])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::UserService.new(
          item: user2,
          current_client: @client,
          current_user: user,
          params: { email: 'zzz@zzz.zz' }
        )
      end

      it 'should not update anything and return false' do
        expect{service.update}.to raise_error(
          ActionController::ParameterMissing,
          'param is missing or the value is empty: user'
        )
        expect(User.count).to eq(5)
        updated_object = User.last

        expect(service.item).to eq(updated_object)
        expect(service.item.email).to eq('aaa@bbb.ccc')
      end
    end
  end

  describe '.destroy' do
    let!(:user2) { create :user, client: @client }

    let!(:service) do
      Api::V1::Services::UserService.new(
        item: user2,
        current_client: @client,
        current_user: user
      )
    end

    it 'should destroy the object and return true' do
      expect(service.destroy).to be_truthy

      expect(User.count).to eq(4)
    end
  end
end
