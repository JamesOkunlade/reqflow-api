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