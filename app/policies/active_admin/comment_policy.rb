class ActiveAdmin::CommentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    case record.name
    when 'Dashboard'
      true
    else
      user.superadmin?
    end
  end
end
