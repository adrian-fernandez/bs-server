module Api
  module V1
    class UserSearch
      def self.search(repository, params)
        search = Search.new(
          repository, params, filters:
            [
              IdsFilter,
              ExcludeIdsFilter,
              QueryFilter
            ]
        )
        search.search
      end

      class IdsFilter
        class << self
          def apply(results, params)
            return results unless params[:ids].present?

            results.where(id: params[:ids])
          end
        end
      end

      class ExcludeIdsFilter
        class << self
          def apply(results, params)
            return results unless params[:exclude_ids].present?

            results.where.not(id: params[:exclude_ids])
          end
        end
      end

      class QueryFilter
        class << self
          def apply(results, params)
            return results unless params[:q].present?

            results.where("email LIKE '%?%'", params[:q])
          end
        end
      end
    end
  end
end
