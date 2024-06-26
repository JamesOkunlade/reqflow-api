class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :requests
  has_many :approval_users
  has_many :approvals, through: :approval_users
  # has_many :approvals_users, dependent: :restrict_with_exception

   # validations
   validates_presence_of :first_name, :last_name, :password_digest
   validates_presence_of :email, uniqness: true
end
