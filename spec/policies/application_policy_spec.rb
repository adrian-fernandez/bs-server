require 'rails_helper'
require 'pundit/rspec'
require 'support/fake_active_record'

RSpec.describe ApplicationPolicy do
  subject { described_class }
  let(:policy_context_superadmin) { Struct.new(:user, :params).new(@superadmin_user, {}) }
  let(:policy_context_admin) { Struct.new(:user, :params).new(@admin_user, {}) }
  let(:policy_context_user) { Struct.new(:user, :params).new(@staff_user, {}) }

  permissions :index? do
    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, FakeActiveRecord.new)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, FakeActiveRecord.new)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, FakeActiveRecord.new)
      end
    end
  end

  permissions :create? do
    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, FakeActiveRecord.new)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, FakeActiveRecord.new)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, FakeActiveRecord.new)
      end
    end
  end

  permissions :update? do
    let!(:test) { FakeActiveRecord.new }

    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, test)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, test)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, test)
      end
    end
  end

  permissions :destroy? do
    let!(:test) { FakeActiveRecord.new }

    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, test)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, test)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, test)
      end
    end
  end

  permissions :edit? do
    let!(:test) { FakeActiveRecord.new }

    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, test)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, test)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, test)
      end
    end
  end

  permissions :new? do
    let!(:test) { FakeActiveRecord.new }

    context 'For superadmins' do
      it 'allows access' do
        expect(subject).to permit(policy_context_superadmin, test)
      end
    end

    context 'For admins' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_admin, test)
      end
    end

    context 'For normal users' do
      it 'denies access' do
        expect(subject).not_to permit(policy_context_user, test)
      end
    end
  end

  permissions :show? do
    context 'when item exists but permissions are not defined' do
      let!(:test) { FakeActiveRecord.new }

      context 'For superadmins' do
        it 'allows access' do
          expect(subject).to permit(policy_context_superadmin, test)
        end
      end

      context 'For admins' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_admin, test)
        end
      end

      context 'For normal users' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_user, test)
        end
      end
    end

    context 'when item doesnt exist' do
      let!(:test) { FakeActiveRecord.new(false) }

      context 'For superadmins' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_superadmin, test)
        end
      end

      context 'For admins' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_admin, test)
        end
      end

      context 'For normal users' do
        it 'denies access' do
          expect(subject).not_to permit(policy_context_user, test)
        end
      end
    end
  end
end
