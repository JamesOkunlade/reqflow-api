# == Schema Information
#
# Table name: approval_users
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  approval_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_approval_users_on_approval_id  (approval_id)
#  index_approval_users_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (approval_id => approvals.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :approval_user do
    user
    approval
  end
end
