FactoryBot.define do
  factory :flight do
    company
    sequence(:name) { |n| "Flight#{n}" }
    base_price 1
    no_of_seats 200
    sequence(:flys_at) { |n| Time.now.utc + n.hours }
    sequence(:lands_at) { |n| Time.now.utc + n.hours + 50.minutes }
  end
end
