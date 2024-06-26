class Approval < ApplicationRecord
  belongs_to :request
  has_many  :approval_users, dependent: :destroy
end
