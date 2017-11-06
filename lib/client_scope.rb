module ClientScope
  class << self
    def included(klass)
      klass.class_eval do
        # Scope Associations
        has_many :users, dependent: :destroy
        has_many :roles, -> { order('roles.id asc') }, dependent: :destroy
        has_many :user_roles, -> { order('user_id asc, role_id asc') }, dependent: :destroy

        has_many :bookings, -> { order('bookings.id asc') }, dependent: :destroy
        has_many :rentals, -> { order('rentals.id asc') }, dependent: :destroy

        extend ClassMethods
        include InstanceMethods
      end
    end
  end

  module InstanceMethods
  end

  module ClassMethods
  end
end
