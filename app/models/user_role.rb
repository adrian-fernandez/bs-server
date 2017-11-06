class UserRole < ApplicationRecord
  has_paper_trail

  acts_as_tenant(:client)

  belongs_to :client
  belongs_to :role
  belongs_to :user

  before_validation :set_client_id

  private
    def set_client_id
      self.client_id = ActsAsTenant.current_tenant.id
    end
end
