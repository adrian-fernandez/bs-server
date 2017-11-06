require 'rails_helper'
require 'pundit/rspec'

RSpec.describe RentalPolicy do
  subject { described_class }
  let(:policy_context_admin) { Struct.new(:user, :params).new(@admin_user, {}) }
  let(:policy_context_user) { Struct.new(:user, :params).new(@staff_user, {}) }

  permissions :create? do
    context 'For admins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_admin, Rental.new)
      end
    end

    context 'For normal users' do
      it 'allows access' do
        expect(subject).to permit(policy_context_user, Rental.new)
      end
    end
  end

  permissions :update? do
    let!(:rental1) { create :rental, user: @staff_user }

    context 'For admins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_admin, rental1)
      end
    end

    context 'For normal users' do
      let!(:rental2) { create :rental }

      context 'My own rental' do
        it 'denies access' do
          expect(subject).to permit(policy_context_user, rental1)
        end
      end

      context 'Another users rental' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_user, rental2)
        end
      end
    end
  end

  permissions :destroy? do
    let!(:rental1) { create :rental, user: @staff_user }

    context 'For admins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_admin, rental1)
      end
    end

    context 'For normal users' do
      let!(:rental2) { create :rental }

      context 'My own rental' do
        it 'denies access' do
          expect(subject).to permit(policy_context_user, rental1)
        end
      end

      context 'Another users rental' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_user, rental2)
        end
      end
    end
  end
end
