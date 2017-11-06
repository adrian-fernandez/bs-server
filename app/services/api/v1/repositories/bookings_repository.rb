module Api
  module V1
    module Repositories
      class BookingsRepository < GenericRepository
        def fuzzy_search_fields
          %w[users.email rentals.name]
        end

        def visible_by(user: nil)
          return @collection = Booking.none if user.nil?
          return @collection if user.admin?

          @collection = @collection.where(user: user)
        end
      end
    end
  end
end
