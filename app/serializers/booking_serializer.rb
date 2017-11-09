class BookingSerializer < ApplicationSerializer
  attributes(
    :id,
    :start_at,
    :end_at,
    :days,
    :price
  )

  has_one :user, embed_in_root: true
  has_one :rental, embed_in_root: true
end
