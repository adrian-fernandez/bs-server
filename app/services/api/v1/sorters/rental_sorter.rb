module Api
  module V1
    module Sorters
      class RentalSorter < GenericSorter
        class << self
          def sortable_fields
            %w[name user daily_rate]
          end

          def direct_sorting_fields
            %w[name daily_rate]
          end

          def default_sortable_field
            :name
          end

          def table_name
            'rentals'
          end

          private

          def sorting_field(params_sort)
            params_sort = default_sortable_field.to_s unless sortable_fields.include?(params_sort)

            case params_sort
            when 'user'
              { condition: 'users.email', joins: :user }
            when *direct_sorting_fields
              { condition: "#{table_name}.#{params_sort}" }
            end
          end
        end
      end
    end
  end
end
