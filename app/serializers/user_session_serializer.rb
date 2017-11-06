# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  access_token :string(128)      not null
#  user_agent   :string
#  ip_address   :inet
#  accessed_at  :datetime
#  revoked_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserSessionSerializer < ApplicationSerializer
  attributes(
    :id,
    :access_token,
    :accessed_at,
    :revoked_at,
    :created_at
  )

  def accessed_at
    object.accessed_at.try(:to_date)
  end
end
