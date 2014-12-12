class Song < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :artist, :title, :url, :artwork
end
