require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations and validations" do
    it { should have_many(:requests) }
    it { should have_many(:approval_users) }
   
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end
end