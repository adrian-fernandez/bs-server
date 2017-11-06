module Api
  module V1
    module Sorters
      class BookingSorter < GenericSorter
        class << self
          def sortable_fields
            %w[rental user start_at end_at days]
          end

          def direct_sorting_fields
            %w[start_at end_at days price]
          end

          def default_sortable_field
            :start_at
          end

          def table_name
            'bookings'
          end

          private

          def sorting_field(params_sort)
            params_sort = default_sortable_field.to_s unless sortable_fields.include?(params_sort)

            case params_sort
            when 'rental'
              { condition: 'rentals.name' }
            when 'user'
              { condition: 'users.email' }
            when *direct_sorting_fields
              { condition: "#{table_name}.#{params_sort}" }
            end
          end
        end
      end
    end
  end
end
