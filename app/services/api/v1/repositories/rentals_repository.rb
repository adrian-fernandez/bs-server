module Api
  module V1
    module Repositories
      class RentalsRepository < GenericRepository
        def fuzzy_search_fields
          %w[name users.email]
        end

        def visible_by(*)
          @collection
        end

        def rental_daily_rate_ranges
          {
            max: @collection.maximum(:daily_rate),
            min: @collection.minimum(:daily_rate)
          }
        end
      end
    end
  end
end
