FactoryGirl.define do
  factory :user_session do
    user
    accessed_at { Time.now.utc }
    access_token { SecureRandom.hex(16) }
  end
end
