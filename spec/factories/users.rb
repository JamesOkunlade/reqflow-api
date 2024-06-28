FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "test@foobar.com" }
    # email { `#{Faker::Name.unique.name}@reqflow.com` }
    password { "foobar" }
  end
end