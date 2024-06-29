# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  clearance_level :integer          default(1), not null
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations and validations" do
    it { should have_many(:requests) }
    it { should have_many(:approval_users) }
   
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:clearance_level) } # validate inclusion in 1,2,3 too
    it { should validate_presence_of(:password_digest) }
  end
end
