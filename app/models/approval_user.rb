class ApprovalUser < ApplicationRecord
  belongs_to :user
  belongs_to :approval
end
