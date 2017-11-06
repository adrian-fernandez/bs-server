class RoleNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value != 'superadmin' || ActsAsTenant.current_tenant.id == 1

    record.errors[attribute] << (options[:message] || I18n.t('errors.role.invalid_name'))
  end
end
