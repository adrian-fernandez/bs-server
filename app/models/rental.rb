class Rental < ApplicationRecord
  has_paper_trail

  acts_as_tenant(:client)

  belongs_to :client
  belongs_to :user
  has_many :bookings, dependent: :destroy

  validates :client, presence: true
  validates :user, presence: true
  validates :name, presence: true, uniqueness: true
  validates :daily_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :sanitize_daily_rate

  def busy_days
    days = []
    bookings.pending.find_each do |booking|
      days << ([Date.today, booking.start_at].max...(booking.end_at)).to_a
    end

    days.flatten
  end

  private

    def sanitize_daily_rate
      self.daily_rate = daily_rate&.round(2)
    end
end
