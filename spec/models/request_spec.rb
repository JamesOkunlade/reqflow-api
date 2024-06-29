# == Schema Information
#
# Table name: requests
#
#  id           :bigint           not null, primary key
#  amount_cents :bigint           not null
#  description  :text
#  status       :string           default("pending")
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
require 'rails_helper'

RSpec.describe Request, type: :model do
  describe "associations and validations" do
    it { should have_many(:approvals) }
  
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:amount) }
  end
end
