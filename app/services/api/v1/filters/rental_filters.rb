module Api
  module V1
    module Filters
      class RentalFilters < GenericFilters
        class NameFilter
          class << self
            def apply(results, params)
              return results unless params[:name].present?

              results.where('name LIKE ?', "%#{params[:name]}%")
            end
          end
        end

        class UserFilter
          class << self
            def apply(results, params)
              return results unless params[:user_filter].present?

              results.where(user_id: params[:user_filter])
            end
          end
        end

        class PriceFromFilter
          class << self
            def apply(results, params)
              return results unless params[:price_from_filter].present?

              results.where('daily_rate >= ?', params[:price_from_filter])
            end
          end
        end

        class PriceToFilter
          class << self
            def apply(results, params)
              return results unless params[:price_to_filter].present?

              results.where('daily_rate <= ?', params[:price_to_filter])
            end
          end
        end
      end
    end
  end
end
