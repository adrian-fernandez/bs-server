module Api
  module V1
    class ClientsController < BaseController
      before_action :require_superadmin

      private

        def object
          :client
        end
    end
  end
end
