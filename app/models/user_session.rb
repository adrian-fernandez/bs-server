class UserSession < ApplicationRecord
  belongs_to :user

  validates :user, presence: true

  before_create :set_unique_token

  scope :active, lambda {
    where('accessed_at >= ? AND revoked_at IS NULL', 2.weeks.ago)
  }
  scope :inactive, lambda {
    where('accessed_at < ? OR revoked_at IS NOT NULL', 2.weeks.ago)
  }

  def self.authenticate(token)
    active.includes(:user).find_by(access_token: token)
  end

  def revoke!
    self.revoked_at = Time.now.utc
    save!
  end

  def access(request)
    self.accessed_at = Time.now.utc.to_s(:iso8601)
    self.ip_address = request.ip
    self.user_agent = request.user_agent
    save
  end

  def self.destroy_aged_sessions
    UserSession.inactive.destroy_all
  end

  def self.newest(user)
    where(user: user).order('accessed_at DESC').limit(1).first
  end

  private

    def set_unique_token
      self.access_token = SecureRandom.hex(16)
    end
end
