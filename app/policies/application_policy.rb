require 'hashie'

class ApplicationPolicy
  attr_reader :user, :params, :record, :permissions

  def initialize(context, record)
    @user = context.class == User ? context : context&.user
    @params = context.class == User ? nil : context&.params
    @record = record
    @permissions = user ? Hashie::Mash.new(user.permissions) : Hashie::Mash.new
  end

  def index?
    can?(__method__)
  end

  def show?
    scope.where(id: record.id).exists? && can?(__method__)
  end

  def create?
    can?(__method__)
  end

  def new?
    can?(__method__)
  end

  def update?
    can?(__method__)
  end

  def edit?
    can?(__method__)
  end

  def destroy?
    can?(__method__)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def can?(method)
    return true if user&.superadmin?

    # permissions = if user
    #   user.permissions
    # else
    #   Role.permissions_guest
    # end
    value = get_permission(method, class_name, user&.permissions)
    evaluate_permissions(value)
  end

  def evaluate_permissions(value)
    return value if [TrueClass, FalseClass].include?(value.class)
    return user.id == record.id if record.class == User
    user.id == record.user_id
  end

  def class_name
    return record.to_s.pluralize.underscore if record.class == Symbol

    record.class.to_s.pluralize.underscore
  end

  def get_permission(method, class_name, permissions)
    return false unless permissions
    permissions.fetch(class_name, {}).fetch(method.to_s.delete('?'), false)
  end

  class Scope
    attr_reader :user, :params, :scope, :permissions

    def initialize(context, scope)
      @user = context
      @scope = scope
      @permissions = user ? Hashie::Mash.new(user.permissions) : Hashie::Mash.new
    end

    def resolve
      scope
    end
  end
end
