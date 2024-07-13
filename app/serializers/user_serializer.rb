class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :clearance_level
end
