module Api
  module V1
    module Sorters
      class ClientSorter < GenericSorter
        class << self
          def sortable_fields
            %w[name]
          end

          def direct_sorting_fields
            %w[name]
          end

          def default_sortable_field
            :name
          end

          def table_name
            'clients'
          end

          private

          def sorting_field(params_sort)
            params_sort = default_sortable_field.to_s unless sortable_fields.include?(params_sort)

            {
              condition: "#{table_name}.#{params_sort}"
            }
          end
        end
      end
    end
  end
end
