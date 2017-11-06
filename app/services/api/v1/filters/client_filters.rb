module Api
  module V1
    module Filters
      class ClientFilters < GenericFilters
        class NameFilter
          class << self
            def apply(results, params)
              return results unless params[:name].present?

              results.where('name LIKE ?', "%#{params[:name]}%")
            end
          end
        end
      end
    end
  end
end
