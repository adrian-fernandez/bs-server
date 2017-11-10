class ApplicationController < ActionController::Base
  include Authorization
  include Authentication
  include Pundit

  protect_from_forgery with: :null_session
  set_current_tenant_through_filter

  after_action :set_csrf_cookie

  rescue_from Pundit::NotAuthorizedError, with: :render_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_authorized

  def set_current_tenant
    ActsAsTenant.current_tenant = current_user&.client
  end

  protected

    def pundit_user
      UserPunditContext.new(current_user, params)
    end

    def render_not_authorized
      render json: { errors: 'Not Found' }, status: 401
    end

    def set_csrf_cookie
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end
end
