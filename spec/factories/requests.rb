# == Schema Information
#
# Table name: requests
#
#  id           :bigint           not null, primary key
#  amount_cents :bigint           not null
#  description  :text
#  status       :string           default("pending")
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  # factory :request do
  #   title { Faker::Lorem.word }
  #   description { Faker::Lorem.paragraph }
  #   amount { Faker::Number.within(range: 100..1000) }
  # end
end
