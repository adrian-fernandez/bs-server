module Api
  module V1
    class Search
      def initialize(repository, params, filters:)
        @params = params
        @filters = filters
        @repository = repository

        build_fuzzy_fields
      end

      def build_fuzzy_fields
        return unless @params.key?(:fuzzy_search_fields)

        parsed_fuzzy = {}
        @params[:fuzzy_search_fields].each do |key|
          if key.include?('.')
            arr = key.split('.').reverse
            parsed_fuzzy.deep_merge! arr[1..-1].inject(arr[0] => @params[:q]) { |memo, i| { i => memo } }
          else
            parsed_fuzzy.merge!(key => @params[:q])
          end
        end

        @params[:fuzzy_search_fields] = parsed_fuzzy
      end

      def search
        @filters.inject(@repository) do |results, filter|
          results = filter.apply(results, @params)

          results
        end
      end
    end
  end
end
