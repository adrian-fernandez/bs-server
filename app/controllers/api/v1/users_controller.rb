module Api
  module V1
    class UsersController < BaseController
      def me
        return head 404 if current_user.blank?

        render json: current_user,
               serializer: UserSerializer,
               root: 'user',
               status: 200
      end

      private

        def object
          :user
        end
    end
  end
end
