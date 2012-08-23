class User < ActiveRecord::Base
  include Jader::Serialize
  jade_serializable :name, :email
end