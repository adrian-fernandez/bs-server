module Api
  module V1
    module Services
      class ClientService < GenericService
        private

          def sanitized_params
            params
              .require(:client)
              .permit(
                :name
              )
          end
      end
    end
  end
end
