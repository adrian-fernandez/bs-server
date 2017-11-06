module AuthLockable
  LOCK_DURATION = 1.day
  MAXIMUM_ATTEMPTS = 5

  def auth_locked?
    auth_locked_at && auth_locked_at + LOCK_DURATION > Time.now.utc
  end

  def auth_failed!
    self.auth_failed_attempts += 1
    if auth_failed_attempts == MAXIMUM_ATTEMPTS
      lock_authorization!
    else
      save(validate: false)
    end
  end

  def lock_authorization!
    self.auth_locked_at = Time.now.utc
    save(validate: false)
  end

  def unlock_authorization!
    self.auth_locked_at = nil
    self.auth_failed_attempts = 0
    save(validate: false)
  end

  alias auth_success unlock_authorization!
end
