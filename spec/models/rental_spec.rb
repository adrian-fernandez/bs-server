# == Schema Information
#
# Table name: rentals
#
#

require 'rails_helper'

RSpec.describe Rental do
  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'should require case sensitive unique value for name' do
    before { create :rental }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
  it { is_expected.to validate_presence_of(:daily_rate) }
  it { is_expected.to validate_numericality_of(:daily_rate).is_greater_than_or_equal_to(0) }

  describe '.busy_days' do
    let(:rental) { create :rental }
    let!(:booking1) { create :booking, rental: rental, start_at: Date.today, end_at: Date.today + 2.days }
    let!(:booking2) { create :booking, rental: rental, start_at: Date.today + 3.days, end_at: Date.today + 4.days }

    it 'should return array with busy days for the rental' do
      expect(rental.busy_days).to eq(
        [
          Date.today,
          Date.today + 1.day,
          Date.today + 3.days
        ]
      )
    end
  end

  describe '.sanitize_daily_rate' do
    let(:rental) { create :rental, daily_rate: 1.166999 }

    it 'should have daily_rate with 2 decimals' do
      expect(rental.daily_rate).to eq(1.17)
    end
  end
end
