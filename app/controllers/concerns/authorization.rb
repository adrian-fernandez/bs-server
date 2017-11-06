module Authorization
  extend ActiveSupport::Concern

  def require_login
    deny_access unless signed_in?
  end

  # def require_admin
  #   deny_access unless admin?
  # end

  def require_superadmin
    deny_access unless superadmin?
  end

  def deny_access(flash_message = nil)
    head :unauthorized
  end
end
