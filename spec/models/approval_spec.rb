require 'rails_helper'

RSpec.describe Approval, type: :model do

  describe "associations" do
    it { should have_many(:approval_users).dependent(:destroy) }
  end
end
