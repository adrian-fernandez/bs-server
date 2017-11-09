class UserSerializer < ApplicationSerializer
  attributes(
    :id,
    :email,
    :admin,
    :permissions
  )

  def admin
    object&.admin?
  end

  has_many :roles, embed_in_root: true
end
