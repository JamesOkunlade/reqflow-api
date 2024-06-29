# == Schema Information
#
# Table name: approvals
#
#  id                    :bigint           not null, primary key
#  approved_amount_cents :bigint           not null
#  approved_at           :datetime
#  confirmed_at          :datetime
#  status                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  confirmed_by_id       :integer
#  request_id            :bigint           not null
#
# Indexes
#
#  index_approvals_on_request_id  (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (request_id => requests.id)
#
class Approval < ApplicationRecord
  belongs_to :request
  has_many  :approval_users, dependent: :destroy

  include AASM

  aasm column: 'status' do
    state :pending, initial: true
    state :approved, :rejected, :cancelled

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: [:approved, :pending], to: :rejected
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end

    event :undo_cancel do
      transitions from: :cancelled, to: :pending
    end

    event :undo_confirm do
      transitions from: [:approved, :rejected], to: :pending
    end

    event :pending do
      transitions from: :rejected, to: :pending
    end
  end
end
