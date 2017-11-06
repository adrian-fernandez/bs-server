FactoryGirl.define do
  factory :booking do
    user
    client
    rental
    sequence(:start_at) { Date.today }
    sequence(:end_at) { Date.today + 1.day }
  end
end
