# == Schema Information
#
# Table name: bookings
#
#

require 'rails_helper'

RSpec.describe Booking do
  subject { build(:booking, start_at: Date.today) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:rental) }

  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:end_at) }

  describe 'start_at and end_at validations' do
    it 'should not allow end_at before start_at' do
      subject.end_at = Date.today - 1.day

      expect(subject.valid?).to be_falsey
    end

    it 'should not allow end_at equals to start_at' do
      subject.end_at = Date.today

      expect(subject.valid?).to be_falsey
    end

    it 'should allow end_at after start_at' do
      subject.end_at = Date.today + 1.day

      expect(subject.valid?).to be_truthy
    end
  end

  describe '.days' do
    it 'should return the days count of the subject' do
      subject.update_attribute(:end_at, Date.today + 1.day)

      expect(subject.days).to eq(1)
    end
  end

  describe '.price' do
    it 'should return the daily_rate of rental * number of days of subject' do
      rental = build(:rental, daily_rate: 1.13)
      subject.rental = rental
      subject.end_at = Date.today + 3.day
      subject.save

      expect(subject.price).to eq(3.39)
    end

    it 'should return the daily_rate of rental * number of days of subject even if rentals is modified' do
      rental = build(:rental, daily_rate: 1.13)
      subject.rental = rental
      subject.end_at = Date.today + 3.day
      subject.save
      rental.update(daily_rate: 2)

      expect(subject.price).to eq(3.39)
    end
  end

  describe '.pending' do
    let(:rental) { create :rental }
    let!(:booking1) { create :booking, rental: rental, start_at: Date.today - 1.day, end_at: Date.today }
    let!(:booking2) { create :booking, rental: rental, start_at: Date.today, end_at: Date.today + 1.day }
    let!(:booking3) { create :booking, rental: rental, start_at: Date.today + 1.day, end_at: Date.today + 2.days }

    it 'should return bookings that have not yet been complete' do
      expect(rental.bookings.pending).to eq([booking2, booking3])
    end
  end
end
