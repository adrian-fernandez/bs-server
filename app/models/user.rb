class User < ApplicationRecord
  # Include default devise modules.
  has_paper_trail

  acts_as_tenant(:client)

  include AuthLockable

  has_secure_password

  has_many :rentals, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :user_sessions, class_name: 'UserSession', dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles

  belongs_to :client

  validates :client, presence: true
  validates :password, length: { minimum: 6 }, allow_blank: false, if: -> { new_record? }
  validates :password, confirmation: true, if: -> { new_record? }
  validates :password_confirmation, presence: true, if: -> { new_record? }
  validates :email, email: { strict_mode: true }, presence: true, uniqueness: true

  before_validation :downcase_email
  before_validation :set_role

  def permissions
    result = {}
    roles.each do |role|
      result = result.deep_merge(role.permissions) do |_k, v1, v2|
        if [v1, v2].include?(true)
          true
        else
          v2.is_a?(String) ? v2 : v1
        end
      end
    end

    result
  end

  def admin?
    roles.map(&:admin?).inject(&:|)
  end

  def superadmin?
    roles.pluck(:name).include?('superadmin')
  end

  def to_s
    email
  end

  private

    def set_role
      self.roles = [Role.user_role(client)] if roles.blank?
    end

    def downcase_email
      self.email = (email || '').downcase
    end
end
