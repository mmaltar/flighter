class SessionSerializer < ActiveModel::Serializer
  attributes :user, :token
end
