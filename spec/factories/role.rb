FactoryGirl.define do
  factory :role do
    client
    sequence(:name) { |n| "Role name #{n}" }
    permissions {}
  end
end
