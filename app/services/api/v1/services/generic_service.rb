module Api
  module V1
    module Services
      class GenericService
        attr_reader :item, :current_client, :current_user, :params

        def initialize(item: nil, current_client: nil, current_user: nil, params: nil)
          @item = item
          @current_client = current_client
          if @current_client.blank?
            @current_client = Client.first
            ActsAsTenant.current_tenant = @current_client
          end
          @current_user = current_user
          @params = if params.class == ActionController::Parameters
            params
          else
            params.present? ? ActionController::Parameters.new(params) : {}
          end
        end

        def update
          return true if @item.update(sanitized_params)

          @item.reload
          false
        end

        def create
          begin
            object_params = sanitized_params
            object_params.merge!(client_id: (@current_client).id) if repository::SCOPED_BY_CLIENT
          rescue ActionController::ParameterMissing
            return false
          end

          @item = class_name.public_send(:new, object_params)

          if @item.respond_to?(:user_id) && @item.user_id.blank? && @current_user.present?
            @item.user_id = @current_user.id
          end

          @item.save
        end

        def destroy
          @item.destroy
        end

        private

          def class_name
            self.class.to_s.split('::').last.gsub(/Service/, '').singularize.constantize
          end

          def repository
            service_name = self.class.to_s.split('::').last.gsub(/Service/, '').pluralize
            "Api::V1::Repositories::#{service_name}Repository".constantize
          end
      end
    end
  end
end
