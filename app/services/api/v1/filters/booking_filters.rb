module Api
  module V1
    module Filters
      class BookingFilters < GenericFilters
        class DateFilter
          class << self
            def apply(results, params)
              return results unless params[:date_filter].present?

              case params[:date_filter]
              when 'all'
                results
              when 'expired'
                results.where('end_at <= ?', Date.today)
              when 'upcoming'
                results.where('start_at >= ?', Date.today)
              end
            end
          end
        end

        class FromFilter
          class << self
            def apply(results, params)
              return results unless params[:from_filter].present?

              results.where('start_at >= :start_date', start_date: params[:from_filter])
            end
          end
        end

        class ToFilter
          class << self
            def apply(results, params)
              return results unless params[:to_filter].present?

              results.where('end_at <= :end_date', end_date: params[:to_filter])
            end
          end
        end
      end
    end
  end
end
