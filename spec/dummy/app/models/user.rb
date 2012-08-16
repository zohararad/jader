class User < ActiveRecord::Base
  include Jade::Serialize
  jade_serializable :name, :email
end