FactoryBot.define do
  factory :user do
    first_name 'Firstname'
    last_name 'Lastname'
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'password'
  end
end
