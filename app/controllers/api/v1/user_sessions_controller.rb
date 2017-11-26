module Api
  module V1
    class UserSessionsController < BaseController
      protect_from_forgery except: :create

      skip_before_action :find_item
      skip_before_action :require_login
      skip_before_action :set_paper_trail_whodunnit

      def create
        user = User.find_by(email: session_params[:email]&.downcase)

        message = create_fail_message(user)

        if message
          respond_to do |format|
            format.json { return render json: { errors: { session: message.html_safe } }, status: 422 }
            format.html do
              flash[:errors] = message.html_safe
              redirect_to login_users_path
            end
          end
        else
          sign_in(user)
          user_session = UserSession.newest(user)
          ActsAsTenant.current_tenant = user.client

          respond_to do |format|
            format.json { render json: serialize_user_session(user_session), status: 201 }
            format.html { redirect_to root_path }
          end
        end
      end

      def destroy
        sign_out
        head 204
      end

      private

        def session_params
          params[:session]&.permit(:email, :password)
        end

        def serialize_user_session(user_session)
          {
            user: UserSerializer.new(user_session.user).as_json['user'],
            session: UserSessionSerializer.new(user_session).as_json['user_session']
          }
        end

        def create_fail_message(user)
          if user.nil?
            I18n.t('flashes.user_session.bad_email_password')
          elsif user.auth_locked?
            I18n.t('flashes.user_session.auth_locked')
          elsif !user.authenticate(session_params[:password])
            user.auth_failed!
            I18n.t('flashes.user_session.bad_email_password')
          end
        end
    end
  end
end
