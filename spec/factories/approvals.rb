# == Schema Information
#
# Table name: approvals
#
#  id                    :bigint           not null, primary key
#  approved_amount_cents :bigint           not null
#  approved_at           :datetime
#  confirmed_at          :datetime
#  status                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  confirmed_by_id       :integer
#  request_id            :bigint           not null
#
# Indexes
#
#  index_approvals_on_request_id  (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (request_id => requests.id)
#
FactoryBot.define do
  factory :approval do
    request
    approved_amount_cents { request.amount_cents }
    status { 'pending' }
  end
end
