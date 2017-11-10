class Booking < ApplicationRecord
  has_paper_trail

  acts_as_tenant(:client)

  belongs_to :client
  belongs_to :user
  belongs_to :rental

  validates :client, presence: true
  validates :user, presence: true
  validates :rental, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :client, presence: true
  validates_date :end_at, after: :start_at

  before_save :update_days
  before_save :set_daily_rate, on: :create
  before_save :update_price

  default_scope do
    select('bookings.*').joins(:user).joins(:rental)
  end

  scope :pending, -> { where('end_at > ?', Date.today) }

  def to_s
    "(#{I18n.l(start_at)} - #{I18n.l(end_at)}) #{rental.name}"
  end

  def update_days
    self.days = end_at.mjd - start_at.mjd
  end

  def update_price
    self.price = (days * daily_rate).round(2)
  end

  private

    def set_daily_rate
      self.daily_rate = rental.daily_rate.round(2)
      self.price = (daily_rate * days).round(2)
    end
end
