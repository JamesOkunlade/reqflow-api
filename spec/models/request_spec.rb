require 'rails_helper'

RSpec.describe Request, type: :model do
  describe "associations and validations" do
    it { should have_many(:approvals) }
  
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:amount) }
  end
end
