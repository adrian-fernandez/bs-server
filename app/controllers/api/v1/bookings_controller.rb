module Api
  module V1
    class BookingsController < BaseController
      before_action :require_login

      private

        def object
          :booking
        end
    end
  end
end
