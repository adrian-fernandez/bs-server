module Api
  module V1
    module Repositories
      class GenericRepository
        PER_PAGE = 25
        SCOPED_BY_CLIENT = true

        attr_reader :current_client, :current_user, :params, :collection

        def initialize(current_client: nil, current_user: nil, params: nil)
          @current_client = current_client
          @current_user = current_user
          @params = params || {}
          @collection = model
          run
        end

        def run
          return @collection = model.none unless respond_to?(:visible_by)
          scoped_by_client if self.class::SCOPED_BY_CLIENT
          visible_by(user: @current_user)
          search
          sort
          select_fields
          paginate
        end

        def meta
          {
            total_pages: total_pages,
            current_page: params.fetch(:page, 0)
          }
        end

        protected

          def total_pages
            return 1 unless paginate?

            @collection.respond_to?(:total_pages) ? @collection.total_pages : 1
          end

          def scoped_by_client
            @collection = @collection.where(client: @current_client)
          end

          def search_filters
            filter_service.constants.map do |filter_name|
              "Api::V1::Filters::#{service_name}Filters::#{filter_name}".constantize
            end
          end

          def search
            add_fuzzy_search_param
            search = Search.new(@collection, @params, filters: search_filters)
            @collection = search.search
          end

          def sort
            @collection = sort_service.sort(@collection, @params)
          end

          def select_fields
            return @collection unless select_fields?

            fields_to_select = selected_fields.select { |field| field unless no_selectable_fields.include?(field) }
            fields_to_select = (fields_to_select | fields_forced_to_select).uniq
            @collection = @collection.select(fields_to_select)
          end

          def fields_forced_to_select
            []
          end

          def paginate
            return @collection unless paginate?

            @collection = @collection.page(@params.fetch(:page, 0))
              .per(params.fetch(:per_page, PER_PAGE))
          end

        private

          def service_name
            self.class.to_s.split('::').last.gsub(/Repository/, '').singularize
          end

          def model
            service_name.constantize
          end

          def sort_service
            Object.const_get("Api::V1::Sorters::#{service_name}Sorter")
          end

          def filter_service
            Object.const_get("Api::V1::Filters::#{service_name}Filters")
          end

          def select_fields?
            selected_fields.count.positive?
          end

          def selected_fields
            @params.fetch(:selected_fields, [])
          end

          def paginate?
            !(@params.fetch(:paginate, nil).present? && @params.fetch(:paginate) == 'false')
          end

          def no_selectable_fields
            []
          end

          def add_fuzzy_search_param
            return if fuzzy_search_fields.blank? || params[:q].blank?
            return @params.merge!(fuzzy_search_fields: fuzzy_search_fields) unless params[:search_fields].present?

            @params[:fuzzy_search_fields] = params[:search_fields] & fuzzy_search_fields

            throw_error_add_fuzzy_search_param
          end

          def throw_error_add_fuzzy_search_param
            return unless @params[:fuzzy_search_fields].blank?

            error_message = I18n.t('errors.service.repository.bad_search_fields', parameters: params[:search_fields])
            raise ArgumentError, error_message
          end
      end
    end
  end
end
