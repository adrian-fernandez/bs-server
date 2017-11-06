module Api
  module V1
    module Services
      class UserService < GenericService
        private

          def sanitized_params
            params
              .require(:user)
              .permit(
                :roles,
                :email,
                :password,
                :password_confirmation
              )
          end
      end
    end
  end
end
