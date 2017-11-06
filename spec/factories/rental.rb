FactoryGirl.define do
  factory :rental do
    user
    client
    sequence(:name) { |n| "n #{n}" }
    daily_rate { Faker::Number.decimal(3) }
  end
end
