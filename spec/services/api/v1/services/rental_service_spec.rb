require 'rails_helper'
RSpec.describe Api::V1::Services::RentalService do
  let!(:user) { create(:user, email: 'aaa@aaa.aaa') }

  describe '.class_name' do
    let!(:service) do
      Api::V1::Services::RentalService.new
    end

    it 'should return the name of the associated class' do
      expect(service.send(:class_name)).to eq(Rental)
    end
  end

  describe '.repository' do
    let!(:service) do
      Api::V1::Services::RentalService.new(
        current_client: @client,
        current_user: user
      )
    end

    it 'should return Api::V1::Repositories::RentalsRepository' do
      expect(service.send(:repository)).to eq(Api::V1::Repositories::RentalsRepository)
    end
  end

  describe '.create' do
    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          current_client: @client,
          current_user: user,
          params: { rental: { name: 'test', daily_rate: 10 } }
        )
      end

      it 'should create the object and return true' do
        expect(service.create).to be_truthy
        expect(Rental.count).to eq(1)

        created_object = Rental.last
        expect(created_object).to eq(service.item)
        expect(created_object.user_id).to eq(user.id)
        expect(created_object.client_id).to eq(@client.id)
        expect(created_object.daily_rate).to eq(10)
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          current_client: @client,
          current_user: user,
          params: { rental: { name: 'test', daily_rate: -10 } }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(Rental.count).to eq(0)
        expect(service.item.errors.messages.keys).to eq([:daily_rate])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          current_client: @client,
          current_user: user,
          params: { daily_rate: 10 }
        )
      end

      it 'should not create anything and return false' do
        expect(service.create).to be_falsey
        expect(Rental.count).to eq(0)
        expect(service.item).to be_nil
      end
    end
  end

  describe '.update' do
    let!(:rental) do
      create :rental,
             name: 'test',
             daily_rate: 10,
             user: user,
             client: @client
    end

    context 'with valid data' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          item: rental,
          current_client: @client,
          current_user: user,
          params: { rental: { name: 'modified name' } }
        )
      end

      it 'should update the object and return true' do
        expect(service.update).to be_truthy
        expect(Rental.count).to eq(1)

        updated_object = Rental.last
        expect(updated_object).to eq(service.item)
        expect(updated_object.user_id).to eq(user.id)
        expect(updated_object.client_id).to eq(@client.id)
        expect(updated_object.name).to eq('modified name')
        expect(updated_object.daily_rate).to eq(10)
      end
    end

    context 'with invalid data' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          item: rental,
          current_client: @client,
          current_user: user,
          params: { rental: { name: '' } }
        )
      end

      it 'should not update anything and return false' do
        expect(service.update).to be_falsey
        expect(service.item.name).to eq('test')
        expect(Rental.count).to eq(1)
        expect(service.item.errors.messages.keys).to eq([:name])
      end
    end

    context 'with invalid data for strong params' do
      let!(:service) do
        Api::V1::Services::RentalService.new(
          item: rental,
          current_client: @client,
          current_user: user,
          params: { name: 'modified name', daily_rate: 1 }
        )
      end

      it 'should not update anything and return false' do
        expect { service.update }.to raise_error(
          ActionController::ParameterMissing,
          'param is missing or the value is empty: rental'
        )
        expect(Rental.count).to eq(1)
        updated_object = Rental.last

        expect(service.item).to eq(updated_object)
        expect(service.item.name).to eq('test')
        expect(service.item.daily_rate).to eq(10)
      end
    end
  end

  describe '.destroy' do
    let!(:rental) { create :rental, client: @client, user: user }

    let!(:service) do
      Api::V1::Services::RentalService.new(
        item: rental,
        current_client: @client,
        current_user: user
      )
    end

    it 'should destroy the object and return true' do
      expect(service.destroy).to be_truthy

      expect(Rental.count).to eq(0)
    end
  end
end
