module Api
  module V1
    module Filters
      class UserFilters < GenericFilters
        class ExcludeRoleIdsFilter
          class << self
            def apply(results, params)
              return results unless params[:exclude_role_ids].present?

              users_with_role = UserRole.where(role_id: params[:exclude_role_ids]).select(:user_id)

              results.where.not(id: users_with_role)
            end
          end
        end

        class EmailFilter
          class << self
            def apply(results, params)
              return results unless params[:email].present?

              results.where('email LIKE ?', "%#{params[:email]}%")
            end
          end
        end
      end
    end
  end
end
