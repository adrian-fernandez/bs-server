module Api
  module V1
    module Services
      class RentalService < GenericService
        private

          def sanitized_params
            params
              .require(:rental)
              .permit(
                :name,
                :user_id,
                :daily_rate
              )
          end
      end
    end
  end
end
