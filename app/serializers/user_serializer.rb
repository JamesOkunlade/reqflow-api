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
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :clearance_level
end
