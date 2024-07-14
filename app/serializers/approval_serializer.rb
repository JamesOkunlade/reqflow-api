class ApprovalSerializer < ActiveModel::Serializer
  attributes :id, :approved_amount_cents, :status, :confirmed_at, :confirmed_by_id

  belongs_to :request
  has_one :user, serializer: UserSerializer


  class RequestSerializer < ActiveModel::Serializer
    attributes :id, :title, :status, :user

    belongs_to :user
  end
end
