class RentalPolicy < ApplicationPolicy
  def rental_daily_rate_ranges?
    true
  end
end
