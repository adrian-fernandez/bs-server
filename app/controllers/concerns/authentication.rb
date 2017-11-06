module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?, :signed_out?, :current_session
  end

  def current_user
    current_user_provider.current_user
  end

  def current_client
    current_user&.client
  end

  # def current_session
  #   current_user_provider.current_session
  # end

  def sign_in(user)
    current_user_provider.sign_in(user, session)
  end

  def sign_out
    current_user_provider.sign_out(session)
  end

  def signed_in?
    current_user.present?
  end

  # def signed_out?
  #   !signed_in?
  # end

  # def admin?
  #   current_user.admin?
  # end

  def superadmin?
    current_user.superadmin?
  end

  private

    def current_user_provider
      @_current_user_provider ||= CurrentUserProvider.new(request.env, request.session)
    end
end
