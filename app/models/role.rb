class Role < ApplicationRecord
  has_paper_trail

  acts_as_tenant(:client)

  has_many :user_roles
  has_many :users, through: :user_roles
  belongs_to :client

  validates :client, presence: true
  validates :name, presence: true, uniqueness: true, role_name: true

  before_create :set_default_permissions

  def admin?
    name == 'admin'
  end

  def superadmin?
    name == 'superadmin'
  end

  def self.user_role(client)
    Role.where(client: client).find_by(name: 'user') ||
      Role.create(name: 'user', client: client)
  end

  def self.permissions_guest
    {
      admin: false,
      rentals: {
        index: true, show: true, create: true, update: false, destroy: false
      },
      bookings: {
        index: true, show: true, create: true, update: false, destroy: false
      },
      users: {
        index: false, show: true, create: false, update: false, destroy: false
      }
    }
  end

  private

    def set_default_permissions
      allowed = admin?
      self.permissions = {
        admin: allowed,
        rentals: {
          index: true, show: true, create: true, update: (allowed || :self), destroy: (allowed || :self)
        },
        bookings: {
          index: true, show: true, create: true, update: (allowed || :self), destroy: (allowed || :self)
        },
        users: {
          index: allowed, show: true, create: allowed, update: (allowed || :self), destroy: (allowed || :self)
        }
      }
    end
end
