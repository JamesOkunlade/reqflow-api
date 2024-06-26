class Request < ApplicationRecord
  belongs_to :user
  has_many  :approvals

  validates_presence_of :title, :description, :amount
end
