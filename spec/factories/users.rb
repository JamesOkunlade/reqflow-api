# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  clearance_level :integer          default(1), not null
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { "foobar" }
    clearance_level { 1 }
  end
end
