class RentalSerializer < ApplicationSerializer
  attributes(
    :id,
    :name,
    :daily_rate
  )

  has_one :user, include: true, serializer: UserSerializer

  def attributes
    hash = super
    excluded_attributes = @serialization_options[:excluded_attributes] || []
    hash['busy_days'] = object.busy_days unless excluded_attributes.include?('busy_days')

    hash
  end
end
