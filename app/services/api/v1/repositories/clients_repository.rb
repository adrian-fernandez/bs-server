module Api
  module V1
    module Repositories
      class ClientsRepository < GenericRepository
        SCOPED_BY_CLIENT = false

        def fuzzy_search_fields
          %w[name]
        end

        def visible_by(*)
          @collection
        end

        private

          def no_selectable_fields
            []
          end
      end
    end
  end
end
