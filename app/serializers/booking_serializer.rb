class BookingSerializer < ApplicationSerializer
  attributes(
    :id,
    :start_at,
    :end_at,
    :days,
    :price
  )

  has_one :user, include: true, embed: :ids
  has_one :rental, include: true, embed: :ids
end
