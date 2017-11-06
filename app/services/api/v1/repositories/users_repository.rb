module Api
  module V1
    module Repositories
      class UsersRepository < GenericRepository
        def fuzzy_search_fields
          %w[email]
        end

        def visible_by(*)
          @collection
        end

        private

          def no_selectable_fields
            [:encrypted_password]
          end

          def fields_forced_to_select
            []
          end
      end
    end
  end
end
