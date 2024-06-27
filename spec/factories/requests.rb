FactoryBot.define do
  factory :request do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    amount { Faker::Number.within(range: 100..1000) }
  end
end