FactoryGirl.define do
  factory :user do
    client
    sequence(:email) { |n| "#{n}.#{Faker::Internet.email}" }
    password 'adrianBookingSync'
    password_confirmation 'adrianBookingSync'
  end
end
