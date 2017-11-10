module Api
  module V1
    class RentalsController < BaseController
      PER_PAGE = 10

      skip_before_action :find_item, only: %i[rental_daily_rate_ranges]

      def rental_daily_rate_ranges
        authorize :rental

        repository = Api::V1::Repositories::RentalsRepository.new(
          current_client: current_client,
          current_user: current_user,
          params: params
        )

        daily_rate_range = repository.rental_daily_rate_ranges

        render json: {
          rental_statistics: {
            min_daily_rate: daily_rate_range[:min],
            max_daily_rate: daily_rate_range[:max]
          }
        }
      end

      private

        def object
          :rental
        end
    end
  end
end
