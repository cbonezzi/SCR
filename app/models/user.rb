class User < ActiveRecord::Base
  has_and_belongs_to_many :songs
  attr_accessible :session_token, :username
end
