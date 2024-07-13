class RequestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :amount_cents, :status

  belongs_to :user, serializer: UserSerializer
  has_many  :approvals
  has_one :pending_approval, serializer: ApprovalSerializer

  class ApprovalSerializer < ActiveModel::Serializer
    attributes :id, :confirmed_at, :confirmed_by_id, :status, :sanitized_user

    has_one :user, serializer: UserSerializer

    def sanitized_user
      object.user.sanitized_user_data if object.user
    end
  end
end
