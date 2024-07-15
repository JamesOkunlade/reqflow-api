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
  has_one :approval_user, dependent: :destroy
  has_one :user, through: :approval_user

  validates :approved_amount_cents, presence: true, numericality: { greater_than: 0 }

  scope :initiated, -> { where(status: ['approved', 'rejected']) }

  include AASM

  aasm column: 'status' do
    state :pending, initial: true
    state :approved, :rejected

    event :approve do
      transitions from: :pending, to: :approved

      after do |user|
        self.update_columns(
          approved_at: Time.current,
          confirmed_at: request.approvals.where(status: 'approved').count == 3 ? Time.current : self.confirmed_at,
          confirmed_by_id: request.approvals.where(status: 'approved').count == 3 ? user.id : self.confirmed_by_id
        )
        request.create_next_approval if request.approvals.where(status: 'approved').count < 3
        ApprovalUser.create!(approval: self, user: user)
      end
    end

    event :reject do
      transitions from: [:approved, :pending], to: :rejected
      after do |user|
        ApprovalUser.create!(approval: self, user: user)
      end
    end
  end

  after_save :check_for_next_approval, if: :approved?

  private

  def check_for_next_approval
    if request.approvals.where(status: 'approved').count < 3 && request.aasm.current_state == 'approval_initiated'
      request.create_next_approval
    end
  end
end
