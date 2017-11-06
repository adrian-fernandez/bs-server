module Api
  module V1
    module Sorters
      class GenericSorter
        class << self
          def sort(collection, params)
            sorting_data = sorting_field(params[:sort_field])

            if sorting_data.fetch(:joins, nil).present?
              collection.joins(sorting_data[:joins])
                .order("#{sorting_data[:condition]} #{sorting_direction(params[:sort_direction])}")
            else
              collection.order("#{sorting_data[:condition]} #{sorting_direction(params[:sort_direction])}")
            end
          end

          protected

          def sorting_direction(params_direction)
            params_direction == 'desc' ? :desc : :asc
          end
        end
      end
    end
  end
end
