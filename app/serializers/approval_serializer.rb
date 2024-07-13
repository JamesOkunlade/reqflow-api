class ApprovalSerializer < ActiveModel::Serializer
  attributes :id, :approved_amount_cents, :status, :confirmed_at, :confirmed_by_id

  belongs_to :request
  has_one :user, serializer: UserSerializer


  class RequestSerializer < ActiveModel::Serializer
    attributes :id, :title, :status, :sanitized_user

    # belongs_to :user, serializer: UserSerializer

    def sanitized_user
      object.user.sanitized_user_data if object.user
    end
  end
end
