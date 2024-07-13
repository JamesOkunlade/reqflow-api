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
class Request < ApplicationRecord
  belongs_to :user 
  has_many  :approvals, dependent: :destroy
  has_one :pending_approval, -> { where(status: "pending") }, class_name: "Approval"

  validates_presence_of :title, :description, :amount_cents
  validates :amount_cents,  numericality: { greater_than: 0 }, allow_nil: true

  default_scope { order(updated_at: :desc) }

  include AASM

  aasm column: 'status' do
    state :requested, initial: true
    state :approval_initiated, :approved, :rejected

    event :initiate_approval do
      transitions from: :requested, to: :approval_initiated
    end

    event :approve do
      transitions from: :approval_initiated, to: :approved, guard: :all_approvals?
    end

    event :reject do
      transitions from: [:requested, :approval_initiated], to: :rejected
    end
  end

  def create_next_approval
    approvals.create!(approved_amount_cents: amount_cents)
  end
  
  def possible_actions
    {
      may_initiate_approval: may_initiate_approval?,
      may_approve: may_approve?,
      may_cancel: may_cancel?,
    }
  end

  private


  def all_approvals?
    approvals.where(status: 'approved').count >= 3
  end
end
