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
class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :requests
  has_many :approval_users
  has_many :approvals, through: :approval_users

  validates :first_name, :last_name, :password_digest, presence: true
  validates :email, presence: true, uniqueness: true
  validates :clearance_level, presence: true, inclusion: { in: [1, 2, 3] }


  def sanitized_user_data
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      clearance_level: clearance_level,
      email: email
    }
  end
end
