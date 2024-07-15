# == Schema Information
#
# Table name: requests
#
#  id           :bigint           not null, primary key
#  amount_cents :bigint           not null
#  description  :text
#  status       :string           default("requested")
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
class RequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :amount_cents, :status

  belongs_to :user, serializer: UserSerializer
  has_many  :approvals
  has_one :pending_approval, serializer: ApprovalSerializer

  class ApprovalSerializer < ActiveModel::Serializer
    attributes :id, :confirmed_at, :confirmed_by_id, :status, :user

    has_one :user, serializer: UserSerializer
  end
end
