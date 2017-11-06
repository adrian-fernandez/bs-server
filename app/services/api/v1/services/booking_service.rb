module Api
  module V1
    module Services
      class BookingService < GenericService
        private

          def sanitized_params
            params
              .require(:booking)
              .permit(
                :rental_id,
                :user_id,
                :start_at,
                :end_at
              )
          end
      end
    end
  end
end
