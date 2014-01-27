class Photo < ActiveRecord::Base
  attr_accessible :title, :image

  has_many :comments, as: :commentable
end
