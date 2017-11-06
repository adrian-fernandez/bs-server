module Api
  module V1
    module Filters
      class GenericFilters
        class QueryFilter
          class << self
            def apply(results, params)
              return results unless params[:q].present?
              return results unless params[:fuzzy_search_fields].present?

              fuzzy_fields = params[:fuzzy_search_fields].permit!.to_hash
              results = build_joins(results, fuzzy_fields)
              results.search(fuzzy_fields, false).except(:order)
            end

            def build_joins(results, fuzzy_fields)
              fuzzy_fields.each_pair do |key, _value|
                join_key = build_nested_key(results, fuzzy_fields, key)
                results = results.joins(join_key) if join_key
              end

              results
            end

            def build_nested_key(results, fuzzy_fields, key)
              return nil unless fuzzy_fields[key].class == Hash

              return key.singularize.to_sym if results.klass.new.respond_to?(key.singularize.to_sym)
              # return key.pluralize.to_sym if results.klass.new.respond_to?(key.pluralize.to_sym)

              nil
            end
          end
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
      end
    end
  end
end
